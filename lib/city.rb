require 'open-uri'
require 'nokogiri'
require 'openssl'

class City
    def initialize(city_name, state_name)
        @city_name = city_name.downcase
        @state_name = state_name.downcase
    end

    def get_cost_of_living
        url = "http://www.bestplaces.net/cost_of_living/city/#{@state_name}/#{@city_name}"
        resultArr = []

=begin
        1. Parsing the HTML with Nokogiri. 
        2. If you're wondering: SSL verifcation when getting site data is being turned off, so that http is used instead. 
        This is not good for production, but as this is just for fun, I'm using this janky approach.
        I won't repeat this comment in other methods, but this is the case for all get methods in this class.
=end

        fullHTML = Nokogiri::HTML.parse(URI.open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)

        # Search for full Cost of Living Table with Nokogiri
        fullTable = fullHTML.css("table#mainContent_dgCostOfLiving").to_s
        allRows = fullTable.split("</tr>")

        # Substring to find individual pieces needed for cost of living
        resultArr << allRows[1].split("</td>")[1][5..] #overall score
        resultArr << allRows[2].split("</td>")[1][5..] #groceries
        resultArr << allRows[4].split("</td>")[1][5..] #housing
        resultArr << allRows[5].split("</td>")[1][5..] #median_home_cost
        resultArr << allRows[6].split("</td>")[1][5..] #utilities
        resultArr << allRows[7].split("</td>")[1][5..] #transport

        # Return an array, the row to be added
        return resultArr
    end

    def get_climate
        return "Data"
    end

    def get_economy
        return "Data"
    end

    def get_politics
        return "Data"
    end

    def get_commute
        return "Data"
    end

    def get_crime
        return "Data"
    end
end

# Testing Area
boston = City.new("Boston", "massachusetts")
puts boston.get_cost_of_living
