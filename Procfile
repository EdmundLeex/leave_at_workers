web: bundle exec unicorn -p $PORT -E $RACK_ENV -c ./config/unicorn.rb
worker: bundle exec sidekiq -r ./app.rb -e production -c 2
