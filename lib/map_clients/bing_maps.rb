# encoding: UTF-8
#############################
# lib/map_clients/bing_maps.rb
#############################
require 'open-uri'
require 'dotenv'

Dotenv.load

module MapClients
  class BingMaps
    attr_reader :raw_response
    attr_reader :json

    attr_reader :status_code

    attr_reader :distance
    attr_reader :duration
    attr_reader :duration_with_traffic

    def initialize
      @api_key = ENV['BING_MAPS_API_KEY']
      @base_url = 'https://dev.virtualearth.net/REST/v1/Routes/Driving'
    end

    def retrieve_direction(options = {})
      options['key'] = @api_key

      options['ra'] = 'routeSummariesOnly' # route attributes
      options['optmz'] = 'timeWithTraffic' # optimize
      options['du'] = 'mi' # distance unit

      @origin = options['wp.1'] = options.delete :origin
      @destination = options['wp.2'] = options.delete :destination

      url = @base_url + '?' + options.compact.collect { |k,v| "#{k}=#{v}" }.join("&")
      @raw_response = open(url).read

      parse_response
    end

    def to_h
      { origin: @origin,
        destination: @destination,
        duration: @duration,
        duration_with_traffic: @duration_with_traffic,
        distance: @distance }
    end

  private

    def parse_response
      @json = JSON.parse(@raw_response)

      @status_code = @json['statusCode']

      resource = @json['resourceSets'].first.resources.first

      @distance = resource['travelDistance']
      @duration = resource['travelDuration']
      @duration_with_traffic = resource['travelDurationTraffic']
    end
  end
end
