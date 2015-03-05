require 'sidekiq'
require_relative '../app'

module Workers
  class Processer
    include Sidekiq::Worker

    LEAD_WAY = 45.minutes

    def perform(options = {})
      options.symbolize_keys!

      @reminder = LeaveAtAPIClient.get(:reminders, options[:reminder_id])
      return unless reminder

      client = MapClients::BingMaps.new
      client.retrieve_direction(origin: @reminder.origin,
                                destination: @reminder.destination)

      return unless client.duration_with_traffic

      leave_at = Time.at(@reminder.arrival_time.to_i - client.duration_with_traffic)
      finish(client.to_h.merge(leave_at: leave_at)) if Time.now >= leave_at - LEAD_WAY
    end

  private

    def finish(options)
      arrival_time = Time.parse @reminder.arrival_time

      options[:arrival_time] = arrival_time.localtime
      options[:email] = @reminder.email

      Mailer.reminder_email(options)

      if new_arrival = calculate_repeat(arrival_time)
        LeaveAtAPIClient.update(:reminders, @reminder.id, arrival_time: new_arrival)
      else
        LeaveAtAPIClient.update(:reminders, @reminder.id, is_finished: true)
      end
    end

     def calculate_repeat(arrival_time)
        @reminder.repeat ? arrival_time + 1.day : nil
     end
  end
end
