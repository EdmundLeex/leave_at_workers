require "sinatra/activerecord/rake"

namespace :db do
  task :load_config do
    require "./app"
  end
end

namespace :test do
  desc 'Run all the tests'
  task :all do
    $LOAD_PATH.unshift('lib', 'tests')
    Dir.glob('./tests/**/*_test.rb') { |f| require f }
  end
end
