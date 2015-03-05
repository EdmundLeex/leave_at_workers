require 'sidekiq'
require_relative '../app'

module Workers
  class Dispatcher
    include Sidekiq::Worker

    def perform
      reminders = LeaveAtAPIClient.get(:reminders)
      reminders.each { |r| Processer.perform_async(reminder_id: r.id) }

      self.class.perform_in 20.minutes
    end
  end
end
