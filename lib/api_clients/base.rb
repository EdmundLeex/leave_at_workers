# encoding: UTF-8
#############################
# lib/api_clients/base.rb
#############################
require 'dotenv'

module ApiClients
  class Base
    def initialize
      Dotenv.load
    end
  end
end
