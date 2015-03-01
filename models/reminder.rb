# encoding: UTF-8

require 'active_record'
require 'pp'

#############################
# models/reminder.rb
#############################
module Models
  class Reminder < ActiveRecord::Base
    def self.active
      where('arrival_time <= ?', Time.now + 3.hours).where(is_finished: false)
    end

    def self.fetch(id)
      find_by(id: id)
    end

    def finish(options = {})
      update(is_finished: true)

pp "arrival_time: #{arrival_time.localtime}"
pp "time now: #{Time.now}"
pp options
      # send_email
    end
  end
end
