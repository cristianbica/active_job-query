require 'test_helper'

class ActiveJobQueryTest < ActiveSupport::TestCase
  setup do
    Sidekiq.redis{|c| c.keys.each{|k| c.del(k) } }
    10.times{ FirstJob.set(queue: 'default').perform_later }
    10.times{ FirstJob.set(queue: 'urgent' ).perform_later }
    10.times{ FirstJob.set(queue: 'default', wait: 10.minutes).perform_later }
    10.times{ FirstJob.set(queue: 'low',     wait: 10.minutes).perform_later }
  end

  teardown do
    Sidekiq.redis{|c| c.keys.each{|k| c.del(k) } }
  end

  test "queues" do
    assert_equal %w(default urgent low), ActiveJob::Query.queues.map(&:name)
  end

  test "queue size" do
    queue = ActiveJob::Query::Queue.new(name: 'default')
    assert_equal 20, queue.size
  end
end
