#############################
# tests/lib/api_clients/leave_at_test.rb
#############################
require_relative '../../test_helper'

class ApiClients::LeaveAtTest < Minitest::Test
  def setup
    @client = ApiClients::LeaveAt.new
    @resp = {'foo' => 'bar'}
  end

  def test_get_success
    RestClient.stub :get, @resp.to_json do
      assert_equal @resp, @client.get(:reminders)
    end
  end

  def test_update_success
    RestClient.stub :post, @resp.to_json do
      assert_equal @resp, @client.update(:reminders, 1, {})
    end
  end
end
