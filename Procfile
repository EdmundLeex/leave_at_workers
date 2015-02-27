web: bundle exec unicorn -p $PORT -E $RACK_ENV -c ./config/unicorn.rb
sidekiq: bundle exec sidekiq -c 2 -r ./app.rb -e production
