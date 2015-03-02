require 'sidekiq'
require_relative '../app'

module Workers
  class Processer
    include Sidekiq::Worker

    LEAD_WAY = 1.hour

    def perform(options = {})
      options.symbolize_keys!

      reminder = Models::Reminder.fetch(options[:reminder_id])
      return unless reminder

      client = MapClients::BingMaps.new
      client.retrieve_direction(origin: reminder.origin,
                                destination: reminder.destination)

      return unless client.duration_with_traffic

      leave_at = Time.at(reminder.arrival_time.to_i - client.duration_with_traffic)
      reminder.finish(client.to_h.merge(leave_at: leave_at)) if Time.now >= leave_at - LEAD_WAY
    end
  end
end
