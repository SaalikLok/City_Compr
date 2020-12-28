require 'open-uri'
require 'nokogiri'
require 'openssl'

class City
    def initialize(city_name, state_name)
        @city_name = city_name
        @state_name = state_name
    end

    def get_cost_of_living
        url = "http://www.bestplaces.net/cost_of_living/city/#{@state_name}/#{@city_name}"
        resultArr = []

        # SSL is being turned off, so that http is used instead. This is not good for production, but as this is just for fun, I'm using this janky approach.
        # Parse the HTML
        fullHTML = Nokogiri::HTML.parse(URI.open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)

        # Search for data in the Cost of Living Table with Nokogiri


        # Return an array, the row to be added
        return fullHTML.title
    end
end