users = [
    {name: 'admin', admin: true, password: 'lolz!234', timezone: 'Eastern Time (US & Canada)' },
    {name: 'test', admin: false, password: 'test0987', timezone: 'Central Time (US & Canada)' }
]

users.each do |u|
    User.create(u)
end

