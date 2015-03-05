require 'sidekiq'
require_relative '../app'

module Workers
  class Processer
    include Sidekiq::Worker

    LEAD_WAY = 2700

    def perform(options = {})
      options.symbolize_keys!

      @reminder = LeaveAtAPIClient.get(:reminders, options[:reminder_id])
      return unless @reminder

      @client = MapClients::BingMaps.new
      @client.retrieve_direction(origin: @reminder.origin,
                                 destination: @reminder.destination)

      return unless @client.duration_with_traffic

      @arrival_time = Time.parse @reminder.arrival_time

      @leave_at = Time.at(@arrival_time.to_i - @client.duration_with_traffic)
      finish if Time.now >= @leave_at - LEAD_WAY
    end

  private

    def finish
      mailer_options = @client.to_h

      mailer_options[:arrival_time] = @arrival_time.localtime
      mailer_options[:email] = @reminder.email
      mailer_options[:leave_at] = @leave_at.localtime

      Mailer.reminder_email(mailer_options)

      if new_arrival = calculate_repeat
        LeaveAtAPIClient.update(:reminders, @reminder.id, arrival_time: new_arrival)
      else
        LeaveAtAPIClient.update(:reminders, @reminder.id, is_finished: true)
      end
    end

     def calculate_repeat
        @reminder.repeat ? @arrival_time + 86400 : nil
     end
  end
end
