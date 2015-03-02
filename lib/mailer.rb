require 'pony'

class Mailer
  class << self
    def reminder_email(options = {})
      time_format = "%I:%M %p"

      subject = "Leave at #{options.leave_at.strftime(time_format)} for your trip to #{options.destination}"

      body = ''
      body = "to: #{options.destination} \n"
      body += "from: #{options.origin} \n\n"

      body += "leave at: #{options.leave_at.strftime(time_format)} \n"
      body += "arrive at: #{options.arrival_time.strftime(time_format)} \n\n"

      body += "with traffic: #{options.duration_with_traffic}\n"
      body += "without traffic: #{options.duration}"

      mail(to: options.email, body: body, subject: subject)
    end

  private

    def mail(options = {})
      options.symbolize_keys!

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
