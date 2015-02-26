# encoding: UTF-8
#############################
# lib/map_clients/google_maps.rb
#############################
require 'open-uri'
require 'dotenv'

Dotenv.load

module MapClients
  class GoogleMaps
    attr_reader :raw_response
    attr_reader :json
    attr_reader :routes
    attr_reader :status
    attr_reader :distance
    attr_reader :duration

    def initialize
      @api_key = ENV['GOOGLE_API_KEY']
      @base_url = 'https://maps.googleapis.com/maps/api/directions/json'
    end

    def retrieve_direction(options = {})
      options[:key] = @api_key
      url = @base_url + '?' + options.to_query

      @raw_response = open(url).read

      parse_response
    end

  private

    def parse_response
      @json = JSON.parse(@raw_response)

      @routes = @json.routes
      @status = @json.status

      legs = @routes.first.legs

      @distance = legs.first.distance
      @duration = legs.first.duration
    end
  end
end
