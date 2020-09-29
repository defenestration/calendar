users = [
    {name: 'admin', admin: true, password: 'lolz!234', timezone: 'Eastern Time (US & Canada)' },
    {name: 'test', admin: false, password: 'test0987', timezone: '-0600' }
]

users.each do |u|
    User.create(u)
end

