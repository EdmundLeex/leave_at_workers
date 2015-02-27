require 'sidekiq'

before_fork do |server, worker|
   @sidekiq_pid ||= spawn("bundle exec sidekiq -c 4 -r ./app.rb -e production")
end

worker_processes 1

after_fork do |server, worker|
  Sidekiq.configure_client do |config|
    config.redis = { :size => 1 }
  end
  Sidekiq.configure_server do |config|
    config.redis = { :size => 4 }
  end
end
