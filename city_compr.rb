# Welcome to City Compr code!

require './lib/compr.rb'

app = Compr.new
app.welcome
category = app.get_category
cities = app.get_city
data = app.get_data
app.show_table
