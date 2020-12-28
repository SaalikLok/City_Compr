# Welcome to City Compr code!

require './lib/city.rb'
require './lib/compr.rb'

app = Compr.new
app.welcome
category = app.get_category
cities = app.get_city

puts category
puts cities

# Loop that many times to ask city name and state name
# lowercase city and state name
# create cities

# ask for "getCategory()" to be added to rows for table

# assemble table based on category and cities

# print out table

# boston = City.new("boston", "massachusetts")
# puts boston.getTitle