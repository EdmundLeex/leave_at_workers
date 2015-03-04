# encoding: UTF-8

require 'active_record'

#############################
# models/reminder.rb
#############################
module Models
  class Reminder < ActiveRecord::Base

    def finish(options = {})
      options[:arrival_time] = arrival_time.localtime
      options[:email] = email

      Mailer.reminder_email(options)

      if new_arrival = calculate_repeat
        update(arrival_time: new_arrival)
      else
        update(is_finished: true)
      end
    end

    def self.active_for(interval)
      where('arrival_time <= ?', Time.now + interval).where(is_finished: false)
    end

    def self.fetch(id)
      find_by(id: id)
    end

  private

    def calculate_repeat
      repeat ? arrival_time + 1.day : nil
    end

  end
end
