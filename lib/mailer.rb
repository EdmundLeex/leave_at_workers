require 'pony'
require 'chronic_duration'
require 'hashie'

class Mailer
  class << self
    def reminder_email(options = {})
      time_format = "%I:%M %p"

      subject = "Leave at #{options.leave_at.strftime(time_format)} for your trip to #{options.destination}"

      body = ''
      body = "#{options.origin} => #{options.destination} \n\n"

      body += "leave at: #{options.leave_at.strftime(time_format)} \n"
      body += "arrive at: #{options.arrival_time.strftime(time_format)} \n\n"


      body += "with traffic: #{ChronicDuration.output(options.duration_with_traffic)}\n"
      body += "without traffic: #{ChronicDuration.output(options.duration)}"

      mail(to: options.email, body: body, subject: subject)
    end

  private

    def mail(options = {})
      Hashie.symbolize_keys! options

      options[:via] = :smtp
      options[:via_options] = mailing_options

      Pony.mail(options)
    end

    def mailing_options
      { address: 'smtp.gmail.com',
        port: '587',
        enable_starttls_auto: true,
        user_name: ENV['GMAIL_USERNAME'],
        password: ENV['GMAIL_PASSWORD'],
        authentication: :plain,
        domain: 'localhost.localdomain' }
    end
  end
end
