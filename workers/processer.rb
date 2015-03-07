require 'sidekiq'
require 'hashie'

require_relative '../app'

module Workers
  class Processer
    include Sidekiq::Worker

    LEAD_WAY = 2700

    def perform(options = {})
      options.symbolize_keys!

      @reminder = ApiClients::LeaveAt.new.get :reminders, options[:reminder_id]
      return unless @reminder

      @client = ApiClients::BingMaps.new
      @client.retrieve_direction origin: @reminder.origin,
                                 destination: @reminder.destination

      return unless @client.duration_with_traffic

      @arrival_time = Time.parse @reminder.arrival_time

      @leave_at = Time.at(@arrival_time.to_i - @client.duration_with_traffic)
      finish if Time.now >= @leave_at - LEAD_WAY
    end

  private

    def finish
      params = if new_arrival = calculate_repeat
                 { arrival_time: new_arrival }
               else
                 { is_finished: true }
               end

      ApiClients::LeaveAt.new.update(:reminders, @reminder.id, params)

      send_email if @reminder.email
    end

    def send_email
      offset = '-08:00'
      mailer_options = @client.to_h

      mailer_options[:arrival_time] = @arrival_time.localtime offset
      mailer_options[:email] = @reminder.email
      mailer_options[:leave_at] = @leave_at.localtime offset

      Mailer.reminder_email(mailer_options)
    end

    def calculate_repeat
      @reminder.repeat ? @arrival_time + 86400 : nil
    end
  end
end
