#!/usr/bin/env ruby
# https://gist.github.com/jtallant/fd66db19e078809dfe94401a0fc814d2
require 'sinatra'
require 'sinatra/activerecord'
require 'active_support/all'
require './models'
require 'sinatra/config_file'

config_file './config/config.yml'

set :bind, '0.0.0.0'
set :logging, true
set :timezone, settings.timezone

enable :sessions
set :session_secret, settings.session_secret
set :sessions, :expire_after => 604800

helpers do
  def loggedin?
    return if @loggedin
    halt 401, "<p>401. Please <a href=/login>login</a>.</p>"
  end
  def admin?
    loggedin?
    return if @loggedin.admin
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized, admin only.\n"
  end
  def logout!
    @loggedin = nil
    session.delete :user
    session.delete :timezone
    session.delete :admin
  end
  def tzconvert(time = Time.now)
    if time.class.name == "Time"
      if @loggedin.timezone
        return time.in_time_zone(@loggedin.timezone).to_s
      else
        return time.in_time_zone(settings.timezone).to_s
      end
      return time.in_time_zone(settings.timezone).to_s
    end
    return "N/A #{time}"
  end
end

before do
  # logger.debug(params) if params
  Time.zone = settings.timezone
  if not session[:timezone].nil?
    Time.zone = session[:timezone] 
  end
  @now = Time.now
  @session = session
  if session[:login_message]
    @login_message = session[:login_message]
    session.delete :login_message
  end
  if not session[:user].nil?
    @loggedin = User.find_by(name: session[:user] )
    @login_message = "You are already logged in as '#{session[:user]}'."
  end

end

get '/' do
  erb "hi #{session[:user]}. The time is: #{Time.zone.now}. Timezone is '#{Time.zone.name}'. "
end

get '/session' do
  erb :session
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(name: params['name'])
  if user.nil?
    session[:login_message] = "Login failed"
    redirect '/login'
  end
  if params['password'] != user.password
    session[:login_message] = "Login failed"
    redirect '/login'
  end
  session[:user] = user.name
  session[:timezone] = user.timezone
  session[:admin] = user.admin
  redirect '/prefs'
end

get '/logout' do
  logout!
  redirect '/login'
end

get '/prefs' do
  loggedin?
  @timezones = ActiveSupport::TimeZone.all
  erb :prefs
end

post '/prefs' do
  loggedin?
  # logger.debug(params)
  @loggedin.timezone = params['timezone']
  @loggedin.password = params['password']
  @loggedin.save
  session[:prefs_message] = "Prefs saved!"
  redirect '/prefs'
end

# get '/users' do
#   admin?
#   @users = User.all
#   erb :users
# end

get '/admin' do
  admin?
  @users = User.all
  erb :admin
end

get '/events' do
  @events = Event.all
  erb :events
end

get '/event/new' do
  loggedin?
  @helpdesks = Helpdesk.all
  @buildings = Building.all
  erb :'event/new'
end

post '/event/new' do
  logger.debug(params)
  # dtstart = params['dtstart']
  # dtend = params['dtend']
  # submitip = params['submitip']
  # building = params['building']
  # hostname = params['hostname']
  # enterprise = params['enterprise']
  # description = params['description']
  # ticketno = params['ticketno']
  # helpdesk = params['helpdesk']
  # downtime = params['downtime']
  event = Event.new do |e|
    params.each do |k,v|
      e[k] = v
    end
  end
  if event.save 
    redirect "/event/#{event.id}"
  end
end

get '/event/:id' do
  @event = Event.find_by(id: params['id'])
  erb :event
end

get '/helpdesks' do
  admin?
  @helpdesks = Helpdesk.all
  erb :helpdesks
end

get '/helpdesks.json' do
  Helpdesk.all.to_json
end