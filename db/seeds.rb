# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

puts "Destroy all products..."
Product.destroy_all
puts "Destroy all farms..."
Farm.destroy_all
puts "Destroy all users..."
User.destroy_all

puts 'Create users...'
cities = %w[marseille, aubagne, cassis, avignon, cavaillon, lyon, bron, annecy, sorgues, grenoble]
users = []
farms = []
5.times do |i|
  user = User.create!(
    first_name: Faker::Name::first_name,
    last_name: Faker::Name::last_name,
    email: Faker::Internet::email,
    address: cities[i],
    password: 'azerty'
    )
  puts "Create #{i} user..."
  users << user
end
puts "#{users.count} users as been creating..."
puts 'Finish to create users...'

puts "Creating farms..."
10.times do |i|
  farm = Farm.create!(
    user: User.first,
    address: cities[i],
    content: Faker::Lorem::paragraph,
  )
  farms << farm
  puts "farm #{i} create"
end
puts "create farms OK"

puts "End of seed..."