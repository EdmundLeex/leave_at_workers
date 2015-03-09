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
      raise "Set LEAVE_AT_API_URL for REST API in .env" unless @base_url

      token = ENV['LEAVE_AT_ACCESS_TOKEN']
      raise "Set LEAVE_AT_ACCESS_TOKEN for REST API in .env" unless token

      @headers = { 'Access-Token' => token }
    end

    def get resource, id = nil
      url = id ? resource.to_s + '/' + id.to_s : resource.to_s
      JSON.parse RestClient.get(@base_url + url, @headers)
    end

    def update resource, id, params = {}
      url = @base_url + resource.to_s + '/' + id.to_s
      JSON.parse RestClient.post(url, params.to_json, @headers)
    end
  end
end
