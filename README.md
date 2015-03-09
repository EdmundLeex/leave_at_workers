# leave_at_workers

Sidekiq workers for leave_at

## Sample .env file
BING_MAPS_API_KEY=somekey
GMAIL_USERNAME=some_email
GMAIL_PASSWORD=your_password
LEAVE_AT_API_URL=http://localhost:9292/api/
LEAVE_AT_ACCESS_TOKEN=some_token

## Start sidekiq
Goto home directory and run: `sidekiq -r './app.rb'`

## Access console
Goto home directory and run: `irb -r './app'`

## Start dispatcher
in console type: `Workers::Dispatcher.perform_async`

## Run tests
`rake test:all`
