# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


User.create(        
  first_name: "Brian",
  last_name: "Simon",
  street: "220 King St. West",
  city: "Toronto",
  country: "Canada",
  email: "brian@kykyu.com",
  password: "12345",
  password_confirmation: "12345",
  contacts: [
    Contact.new(
      first_name: "Dom",
      last_name: "Schuwey",
      street: "320 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "dom@kykyu.com"
    ), 
    Contact.new(
      first_name: "Taha",
      last_name: "Jalil",
      street: "500 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "taha@kykyu.com"      
    ),
    Contact.new(
      first_name: "Steve",
      street: "600 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "steve@kykyu.com"      
    ),
    Contact.new(
      first_name: "Adriana",
      street: "60 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "adriana@kykyu.com"      
    ),
    Contact.new(
      first_name: "Sanborn",
      street: "100 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "sanborn@kykyu.com"      
    )
  ]
)

User.create(        
  first_name: "Dom",
  last_name: "Schuwey",
  street: "320 King St. West",
  city: "Toronto",
  country: "Canada",
  email: "dom@kykyu.com",
  password: "12345",
  password_confirmation: "12345",
  contacts: [
    Contact.new(
      first_name: "Brian",
      last_name: "Simon",
      street: "220 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "brian@kykyu.com"
    ), 
    Contact.new(
      first_name: "Taha",
      last_name: "Jalil",
      street: "500 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "taha@kykyu.com"      
    ),
    Contact.new(
      first_name: "Steve",
      street: "600 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "steve@kykyu.com"      
    ),
    Contact.new(
      first_name: "Josh",
      street: "700 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "josh@kykyu.com"      
    ),
    Contact.new(
      first_name: "Ian",
      street: "640 King St. West",
      city: "Toronto",
      country: "Canada",
      email: "ian@kykyu.com"      
    )
  ]
)

