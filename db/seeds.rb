require 'faker'

# Create Users
10.times do
  user = User.new(
    name:     Faker::Name.name,
    email:    Faker::Internet.email,
    password: Faker::Lorem.characters(10)
  )
  user.skip_confirmation!
  user.save!
end
users = User.all

# Note: by calling `User.new` instead of `create`,
 # we create an instance of User which isn't immediately saved to the database.

 # The `skip_confirmation!` method sets the `confirmed_at` attribute
 # to avoid triggering an confirmation email when the User is saved.

 # The `save` method then saves this User to the database.

# Create Items
# 100.times do
#   Item.create!(
#   user: users.sample,
#   name: Faker::Lorem.sentence
#   )
# end

user = User.first
user.skip_reconfirmation!
user.update_attributes!(
  name:     'paco',
  email:    'palmtreerooskee@gmail.com',
  password: 'helloworld'
)

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Item.count} items created"
