require 'open-uri'
require 'nokogiri'
require 'openssl'

class City
    def initialize(city_name, state_name)
        @city_name = city_name
        @state_name = state_name
    end

    def getTitle
        url = "http://www.bestplaces.net/cost_of_living/city/#{@state_name}/#{@city_name}"
        fullHTML = Nokogiri::HTML.parse(URI.open(url, {ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE}).read)
        return fullHTML.title
    end
end