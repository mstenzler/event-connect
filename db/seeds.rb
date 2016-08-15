# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create([ 
  { display_name: "Mike", email: "mike@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Male", is_admin: true},
  { display_name: "Mike1", email: "mike1@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Male"},
  { display_name: "Mike2", email: "mike2@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Male"},
  { display_name: "Mike3", email: "mike3@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Male"},
  { display_name: "Mike4", email: "mike4@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Male"},
  { display_name: "Mike5", email: "mike5@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Male"},
  { display_name: "Mike6", email: "mike6@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Male"},
  { display_name: "Mike7", email: "mike7@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Male"},
  { display_name: "Mike8", email: "mike8@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Male"},
  { display_name: "Anne", email: "anne@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Female"},
  { display_name: "Anne2", email: "anne2@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Female"},
  { display_name: "Anne3", email: "anne3@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Female"},
  { display_name: "Alice", email: "alice@nexuscafe.com", password: "foobar", password_confirmation: "foobar", gender: "Female"}
  ])