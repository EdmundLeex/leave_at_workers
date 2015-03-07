# encoding: UTF-8
#############################
# lib/api_clients/leave_at.rb
#############################
require 'rest-client'

module ApiClients
  class LeaveAt < Base
    def initialize
      super

      @base_url = ENV['LEAVE_AT_API_URL']
    end

    def get(resource, id = nil)
      url = id ? resource.to_s + '/' + id.to_s : resource.to_s
      JSON.parse RestClient.get(@base_url + url)
    end

    def update(resource, id, params)
      url = @base_url + resource.to_s + '/' + id.to_s
      JSON.parse RestClient.post(url, params.to_json)
    end
  end
end
