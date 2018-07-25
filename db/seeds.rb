# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.first

15.times do
  name = "#{Faker::Lorem.word}"
  location = "#{Faker::Address.street_name}, #{Faker::Address.city}"
  date = Faker::Date.between(2.years.ago, Date.today)
  user.events.create(name: name,
                     location: location, 
                     registration_start: date - 30, 
                     registration_end: date - 17, 
                     event_start: date - 2, 
                     event_end: date, 
                     short_desc: Faker::Lorem.sentence, 
                     long_desc: Faker::Lorem.paragraphs(3).join("\r\n"),
                     picture: 'default-event-avatar.png')

end

15.times do
  name = "#{Faker::Lorem.word}"
  location = "#{Faker::Address.street_name}, #{Faker::Address.city}"
  date = Faker::Date.between(14.days.ago, Date.today)
  user.events.create(name: name,
                     location: location, 
                     registration_start: date, 
                     registration_end: date + 20, 
                     event_start: date + 30, 
                     event_end: date + 32, 
                     short_desc: Faker::Lorem.sentence, 
                     long_desc: Faker::Lorem.paragraphs(3).join("\r\n"),
                     picture: 'default-event-avatar.png')

end