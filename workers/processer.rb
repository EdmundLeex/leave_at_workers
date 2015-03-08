require 'sidekiq'

require_relative '../app'

module Workers
  class Processer
    include Sidekiq::Worker

    LEAD_WAY = 2700

    def perform options = {}
      options.symbolize_keys!

      @reminder = ApiClients::LeaveAt.new.get :reminders, options[:reminder_id]
      return unless @reminder

      @map_client = ApiClients::BingMaps.new
      @map_client.retrieve_direction origin: @reminder.origin,
                                 destination: @reminder.destination

      return unless @map_client.duration_with_traffic

      @arrival = Time.parse @reminder.arrival_time
      @leave = Time.at(@arrival.to_i - @map_client.duration_with_traffic)

      finish if Time.now >= @leave - LEAD_WAY
    end

  private

    def finish
      update_reminder
      send_email
    end

    def update_reminder
      params = if new_arrival = calculate_repeat
                 { arrival_time: new_arrival }
               else
                 { is_finished: true }
               end

      ApiClients::LeaveAt.new.update(:reminders, @reminder.id, params)
    end

    def send_email
      return unless @reminder.email

      ReminderMailer.perform_async @reminder.email, @arrival, @leave, @map_client.to_h
    end

    def calculate_repeat
      @reminder.repeat ? @arrival + 86400 : nil
    end
  end
end
