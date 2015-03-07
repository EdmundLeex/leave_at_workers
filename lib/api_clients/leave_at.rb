# encoding: UTF-8
#############################
# lib/api_clients/leave_at.rb
#############################
require 'rest-client'

module ApiClients
  class LeaveAt < Base
    BASE_URL = ENV['LEAVE_AT_API_URL'] || 'http://localhost:9292/api/'

    def get(resource, id = nil)
      url = id ? resource.to_s + '/' + id.to_s : resource.to_s
      JSON.parse RestClient.get(BASE_URL + url)
    end

    def update(resource, id, params)
      url = BASE_URL + resource.to_s + '/' + id.to_s
      JSON.parse RestClient.post(url, params.to_json)
    end
  end
end
