require "active_job/query/version"

module ActiveJob
  module Query
    extend ActiveSupport::Autoload

    autoload :Job
    autoload :Jobs
    autoload :Mixin
    autoload :Queue
    autoload :Queues
    autoload :Adapters

    # Returns a list of queues an adapter is aware of.
    #
    # ==== Options
    # * <tt>:adapter</tt> - An ActiveJob adapter. Default is the default ActiveJob adapter
    #
    # ==== Returns
    # * <tt>ActiveJob::Query::Queues</tt> - A collection of queues.
    #
    # ==== Examples
    #
    #    # queues for the default adapter (ApplicationJob.queue_adapter or ActiveJob::Base.queue_adapter)
    #    ActiveJob::Query.queues
    #    # queues for a specific adapter
    #    ActiveJob::Query.queues(adapter: MyJob.queue_adapter)
    def self.queues(adapter: nil)
      ActiveJob::Query::Queues.new(adapter: adapter)
    end

    # Returns a list of jobs.
    #
    # ==== Options
    # * <tt>:queue</tt> - An ActiveJob::Query::Queue instance
    # * <tt>:queue_name</tt> - A queue name. You must specify this unless you
    #   provide the above queue
    # * <tt>:adapter</tt> - An ActiveJob adapter. Default is the default
    #   ActiveJob adapter. You must specify this unless you privide the queue
    #   parameter
    # * <tt>:type</tt> - The type of the job:
    #   - all - All jobs
    #   - enqueued - Enqueued jobs that will be run asap
    #   - scheduled - Jobs scheduled to run in the future
    #   - failed - Jobs that failed and that will never be executed again
    # * <tt>:klass</tt> - Filter the result by the job Class
    #
    # ==== Returns
    # * <tt>ActiveJob::Query::Jobs</tt> - A collection of jobs.
    #
    # ==== Examples
    #
    #    # jobs on the default adapter on the 'default' queue
    #    ActiveJob::Query.jobs
    #    # jobs on a named queue, on the default adapter
    #    ActiveJob::Query.jobs(queue_name: 'urgent')
    #    # jobs on a named queue, on a specific adapter
    #    ActiveJob::Query.jobs(queue_name: 'urgent', adapter: MyJob.queue_adapter)
    #    # jobs on a queue
    #    ActiveJob::Query.jobs(queue: ActiveJob::Query::Queue.new(name: 'urgent', adapter: MyJob.queue_adapter))
    def self.jobs(queue: nil, queue_name: nil, adapter: nil, type: :all, klass: nil)
      ActiveJob::Query::Jobs.new(queue: queue, queue_name: queue_name, adapter: adapter, type: type, klass: klass)
    end

    def self.query_adapter(queue_adapter) #:nodoc:
      name = queue_adapter.is_a?(Class) ? queue_adapter.name.demodulize : queue_adapter.class.name.demodulize
      Adapters.const_get(name)
    end
  end
end

require 'active_job/query/railtie' if defined?(Rails)
