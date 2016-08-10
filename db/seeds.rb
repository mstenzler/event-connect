# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = User.create([ { display_name: "Mike1", email: "mike1@example.com", password: "foobar", password_confirmation: "foobar"},
  { display_name: "Mike1", email: "mike1@example.com", password: "foobar", password_confirmation: "foobar"},
  { display_name: "Mike2", email: "mike2@example.com", password: "foobar", password_confirmation: "foobar"},
  { display_name: "Mike3", email: "mike3@example.com", password: "foobar", password_confirmation: "foobar"},
  { display_name: "Mike4", email: "mike4@example.com", password: "foobar", password_confirmation: "foobar"},
  { display_name: "Mike5", email: "mike5@example.com", password: "foobar", password_confirmation: "foobar"},
  { display_name: "Mike6", email: "mike6@example.com", password: "foobar", password_confirmation: "foobar"},
  { display_name: "Mike7", email: "mike7@example.com", password: "foobar", password_confirmation: "foobar"},
  { display_name: "Mike8", email: "mike8@example.com", password: "foobar", password_confirmation: "foobar"}
  ])