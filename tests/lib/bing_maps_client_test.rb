#############################
# tests/bing_maps_client_test.rb
#############################
require_relative '../test_helper'

class BingMapsClientTest < Minitest::Test
  def setup
    @client = MapClients::BingMaps.new
  end

  def test_retrieve_direction_success
    options = { origin: 'El Monte, CA',
                destination: 'Culver City, CA' }

    VCR.use_cassette('bing_maps_client_success') do
      @client.retrieve_direction(options)
    end

    assert_equal 200, @client.status_code

    refute_nil @client.distance
    refute_nil @client.duration
    refute_nil @client.duration_with_traffic
  end

  def test_retrieve_direction_fail
    assert_raises OpenURI::HTTPError do
      VCR.use_cassette('bing_maps_client_fail') do
        @client.retrieve_direction
      end
    end
  end
end