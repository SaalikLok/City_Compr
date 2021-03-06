require 'terminal-table'
require './lib/city.rb'

class Compr
    def welcome
        puts %{
                         ^
            _______     ^^^
           |xxxxxxx|  _^^^^^_
           |xxxxxxx| | [][]  |
        ______xxxxx| |[][][] |
       |++++++|xxxx| | [][][]|      CITY COMPR
       |++++++|xxxx| |[][][] |      city data comparison
       |++++++|_________ [][]|
       |++++++|=|=|=|=|=| [] |      by @saaliklok
       |++++++|=|=|=|=|=|[][]|
___________|++HH++|  _HHHH__|   _________   _________  _________
     _______________   ______________      ______________
__________________  ___________    __________________    ____________
        }
    end

    # Main Menu, ask which category to look at and how many cities to compare
    def get_category
        puts
        puts
        puts "What category are you investigating today? (Type the number of the option you'd like.)"
        puts "1. Cost of Living"
        puts "2. Climate"
        puts "3. Economy"
        puts "4. Politics"
        puts "5. Commute"
        puts "6. Crime"
        puts
        print "Your answer here: "
        category_input = gets.chomp.to_i

        if category_input.is_a? Numeric
            case category_input
                when 1
                    category = "Cost of Living"
                when 2
                    category = "Climate"
                when 3
                    category = "Economy"
                when 4
                    category = "Politics"
                when 5
                    category = "Commute"
                when 6
                    category = "Crime"
                else
                    puts "Hmm, didn't quite get that. Did you use a number between 1 and 6?"
                    puts
                    exit
            end
            puts "Got it. #{category} it is."
            puts
            return category
        end
    end

    # Ask how many cities to compare, return a hash with cities and states to use in URL lookup
    def get_city
        puts "How many cities would you like to compare?"
        num_cities = gets.to_i
        city_hash = {}

        if num_cities <= 0 || num_cities >= 11
            puts "Hmm, that doesn't look like a valid number. Try something between 1 and 10"
            exit
        end

        num_cities.times do |i|
            city_state_arr = []
            
            print "City name: "
            city = gets.chomp
            city_state_arr << city

            print "State name: "
            state = gets.chomp
            city_state_arr << state

            city_hash[i] = city_state_arr
            puts "Added #{city}, #{state} to the list of cities to compare."
            puts
        end

        puts "On it. Generating data..."

        return city_hash
    end

    # Make city objects and get requested data
    def get_data(category, cities)
        cities_arr = []
        data_arr = []

        cities.each { |key, value| 
            city = value[0].downcase
            state = value[1].downcase
            cities_arr << City.new(city, state)
        }

        case category
        when "Cost of Living"
            headings = ["City", "Overall Score", "Groceries", "Housing", "Median Home Cost", "Utilities", "Transport"]
            cities_arr.each { |city| 
                data_arr << city.get_cost_of_living
            }
            return [headings, data_arr]
        when "Climate"
            headings = ["City", "Comfort Index", "Rainfall", "Snowfall", "Precipitation", "Sunny Days", "High Temp (July)", "Low Temp (Jan)"]
            cities_arr.each { |city| 
                data_arr << city.get_climate
            }
            return [headings, data_arr]
        when "Economy"
            headings = ["City", "Unemployment", "Recent Job Growth", "Future Job Growth", "Income Tax", "Income Per Capita", "Sales Tax"]
            cities_arr.each { |city| 
                data_arr << city.get_economy
            }
            return [headings, data_arr]
        when "Politics"
            headings = ["City", "Political Climate", "Last 5 Presidential Election Results"] 
            cities_arr.each { |city| 
                data_arr << city.get_politics
            }
            return [headings, data_arr]
        when "Commute"
            headings = ["City", "Commute Time", "Auto", "Carpool", "Mass Transit", "Bike", "Walk"]
            cities_arr.each { |city| 
                data_arr << city.get_commute
            }
            return [headings, data_arr]
        when "Crime"
            headings = ["City", "Violent Crime", "Property Crime"]
            cities_arr.each { |city| 
                data_arr << city.get_crime
            }
            return [headings, data_arr]
        end
    end

    # Build and print the table
    def show_table(data, title)
        table = Terminal::Table.new :title => title, :headings => data[0], :rows => data[1]
        puts `clear`
        puts table

    rescue NoMethodError
        puts "ERROR>>> Oops! Looks like at least one of the cities or states you entered weren't valid. Unfortunately, spelling counts :("
        exit
    end
end