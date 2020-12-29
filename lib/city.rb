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

        # Search for cost of living table on page
        fullTable = fullHTML.css("table#mainContent_dgCostOfLiving").to_s
        allRows = fullTable.split("</tr>")

        # Substring to find individual pieces needed for cost of living
        resultArr << @city_name.capitalize
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
        url = "http://www.bestplaces.net/climate/city/#{@state_name}/#{@city_name}"
        resultArr = []

        fullHTML = Nokogiri::HTML.parse(URI.open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)

        # Search for climate data table on page
        fullTable = fullHTML.css("table#mainContent_dgClimate").to_s
        allRows = fullTable.split("</tr>")

        # Substring to find individual pieces needed for climate
        resultArr << @city_name.capitalize
        resultArr << allRows[7].split("</td>")[1][20..] #comfort_index
        resultArr << allRows[1].split("</td>")[1][20..] #rainfall
        resultArr << allRows[2].split("</td>")[1][20..] #snowfall
        resultArr << allRows[3].split("</td>")[1][20..] #precipitation
        resultArr << allRows[4].split("</td>")[1][20..] #sunny_days
        resultArr << allRows[5].split("</td>")[1][20..] #july_high
        resultArr << allRows[6].split("</td>")[1][20..] #jan_low

        return resultArr
    end

    def get_economy
        url = "http://www.bestplaces.net/economy/city/#{@state_name}/#{@city_name}"
        resultArr = []

        fullHTML = Nokogiri::HTML.parse(URI.open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)

        # Search for economy data table on page
        fullTable = fullHTML.css("table#mainContent_dgEconomy").to_s
        allRows = fullTable.split("</tr>")

        # Substring to find individual pieces needed for economy
        resultArr << @city_name.capitalize
        resultArr << allRows[1].split("</td>")[1][5..] #unemployment
        resultArr << allRows[2].split("</td>")[1][5..] #recent_job_growth
        resultArr << allRows[3].split("</td>")[1][5..] #future_job_growth
        resultArr << allRows[5].split("</td>")[1][5..] #income_tax
        resultArr << allRows[6].split("</td>")[1][5..] #income_per_capita
        resultArr << allRows[4].split("</td>")[1][5..] #sales_tax

        return resultArr
    end

    def get_politics
        url = "http://www.bestplaces.net/voting/city/#{@state_name}/#{@city_name}"
        resultArr = []

        fullHTML = Nokogiri::HTML.parse(URI.open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)

        resultArr << @city_name.capitalize

        # Search for political climate text on page (the first bolded element)
        poli_climate_tag = (fullHTML.css("b").first.to_s)
        poli_climate_index = poli_climate_tag.index("is")
        resultArr << poli_climate_tag[poli_climate_index+3..-6] #political climate text
        
        # Search for VoteWord on page
        voteword_tag = fullHTML.css("h5.font-weight-bold").to_s.split("</h5>")[1]
        resultArr << voteword_tag[-9..]

        return resultArr
    end

    def get_commute
        url = "http://www.bestplaces.net/transportation/city/#{@state_name}/#{@city_name}"
        resultArr = []

        fullHTML = Nokogiri::HTML.parse(URI.open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)

        # Search for commute data table on page
        fullTable = fullHTML.css("table#mainContent_dgTransportation").to_s
        allRows = fullTable.split("</tr>")        
        
        # Substring to find individual pieces needed for commute
        resultArr << @city_name.capitalize
        resultArr << allRows[1].split("</td>")[1][5..] #commute_time
        resultArr << allRows[3].split("</td>")[1][5..] #auto%
        resultArr << allRows[4].split("</td>")[1][5..] #carpool%
        resultArr << allRows[5].split("</td>")[1][5..] #mass_transit%
        resultArr << allRows[6].split("</td>")[1][5..] #bike%
        resultArr << allRows[7].split("</td>")[1][5..] #walk%

        return resultArr
    end

    def get_crime
        url = "http://www.bestplaces.net/crime/city/#{@state_name}/#{@city_name}"
        resultArr = []

        fullHTML = Nokogiri::HTML.parse(URI.open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)

        # Both of the crime stats are in h5 tags on this site, so we get all of them and split them into an array.
        h5textArr = fullHTML.css("h5").to_s.split("</h5>")

        resultArr << @city_name.capitalize
        
        # Search for Violent Crime Score (US avg is 22.7)
        violent_crime_index = h5textArr[1].index("is")+3
        violent_crime_end_index = h5textArr[1].index("<small>")-2
        resultArr << h5textArr[1][violent_crime_index..violent_crime_end_index]

        # Search for Property Crime Score (US avg is 35.4)
        property_crime_index = h5textArr[2].index("is")+3
        property_crime_end_index = h5textArr[2].index("<small>")-2
        resultArr << h5textArr[2][property_crime_index..property_crime_end_index]

        return resultArr
    end
end
