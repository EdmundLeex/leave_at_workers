#############################
# tests/google_maps_client_test.rb
#############################
require_relative '../test_helper'

class GoogleMapsClientTest < Minitest::Test
  def setup
    @options = { origin: 'El Monte, CA',
                 destination: 'Culver City, CA',
                 departure_time: :now,
                 alternative: :true }

    @client = MapClients::GoogleMaps.new
  end

  def test_retrieve_direction
    VCR.use_cassette('google_maps_client') { @client.retrieve_direction(@options) }

    refute_nil @client.distance
    refute_nil @client.duration
  end
end
