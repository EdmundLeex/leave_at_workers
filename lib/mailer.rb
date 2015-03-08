require 'pony'
require 'dotenv'

class Mailer
  def self.mail options = {}
    Dotenv.load

    options.symbolize_keys!

    options[:via] = :smtp
    options[:via_options] = via_options

    Pony.mail options
  end

  private

  def self.via_options
    { address: 'smtp.gmail.com',
      port: '587',
      enable_starttls_auto: true,
      user_name: ENV['GMAIL_USERNAME'],
      password: ENV['GMAIL_PASSWORD'],
      authentication: :plain,
      domain: 'localhost.localdomain' }
  end
end
