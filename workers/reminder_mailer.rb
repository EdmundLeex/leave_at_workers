require 'sidekiq'
require 'chronic_duration'

require_relative '../app'

module Workers
  class ReminderMailer < Mailer
    include Sidekiq::Worker

    def perform email, arrival_time, leave_at, options = {}
      offset = '-07:00'

      options.email = email

      options.arrival_time = Time.parse(arrival_time).localtime offset
      options.leave_at = Time.parse(leave_at).localtime offset

      mail options
    end

  private

    def mail options = {}
      time_format = "%I:%M %p"

      subject = "Leave at #{options.leave_at.strftime(time_format)} for your trip to #{options.destination}"

      body = ''
      body = "#{options.origin} => #{options.destination} \n\n"

      body += "leave at: #{options.leave_at.strftime(time_format)} \n"
      body += "arrive at: #{options.arrival_time.strftime(time_format)} \n\n"


      body += "with traffic: #{ChronicDuration.output(options.duration_with_traffic)}\n"
      body += "without traffic: #{ChronicDuration.output(options.duration)}"

      Mailer.mail to: options.email, body: body, subject: subject
    end
  end
end
