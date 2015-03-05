# encoding: UTF-8
#############################
# lib/map_clients/api_client.rb
#############################
require 'rest-client'

class LeaveAtAPIClient
  BASE_URL = 'http://localhost:9292/api/'

  class << self
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
