FROM ruby:2.7.1

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1
ENV RAILS_ENV=development

WORKDIR /usr/src/app

COPY Gemfile ./
RUN apt -y update && apt -y install libldap2-dev libsasl2-dev vim sudo
RUN bundle install

COPY . .

CMD ruby app.rb

