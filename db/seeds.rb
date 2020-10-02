users = [
    {name: 'admin', admin: true, password: 'lolz!234', timezone: 'Eastern Time (US & Canada)' },
    {name: 'test', admin: false, password: 'test0987', timezone: 'Central Time (US & Canada)' }
]

users.each do |u|
    User.create(u)
end

Helpdesk.create( name: "example_hd", url: "http://example.com/ticket/%s", enabled: true )

buildings = [
    {name: "DC2", description: "Lansing DC2", enabled: true},
    {name: "DC3", description: "Lansing DC3", enabled: true},
    {name: "DC4", description: "Phoenix DC4", enabled: true}
]
buildings.each do |b|
    Building.create(b)
end