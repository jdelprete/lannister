# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

uk_counties = YAML.load_file("#{Rails.root}/data/uk_counties.yml")
UkCounty.create(uk_counties.map { |p, c| { postcode_district: p, county: c } })
