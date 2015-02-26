require 'sidekiq'

class SendReminder
  include Sidekiq::Worker

  def perform
    puts 'something'
  end
end
