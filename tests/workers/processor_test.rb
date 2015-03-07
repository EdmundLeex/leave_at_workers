#############################
# tests/workers/processor_test.rb
#############################
require_relative '../test_helper'

require 'sidekiq/testing'

class Workers::ProcesserTest < Minitest::Test
  def setup
    Sidekiq::Testing.fake!
    @worker_class = Workers::Processer
  end

  def test_perform
    assert_equal 0, @worker_class.jobs.size

    @worker_class.perform_async

    assert_equal 1, @worker_class.jobs.size
  end
end
