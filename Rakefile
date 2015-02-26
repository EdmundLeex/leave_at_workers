namespace :test do
  desc 'Run all the tests'
  task :all do
    $LOAD_PATH.unshift('lib', 'tests')
    Dir.glob('./tests/**/*_test.rb') { |f| require f }
  end
end
