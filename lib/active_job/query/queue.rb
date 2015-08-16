module ActiveJob
  module Query
    # = ActiveJob Queue
    #
    # Hold the details of a queue. You can get statistics of a queue,
    # the jobs enqueued on a queue or manipulate the jobs.
    #
    # Usage:
    #
    #   queue = ActiveJob::Query::Queue.new()
    #   queue.size
    #   queue.jobs
    class Queue
      attr_accessor :name, :adapter

      # Returns a queue of an adapter.
      #
      # ==== Options
      # * <tt>:name</tt> - The queue name. Default is 'default'
      # * <tt>:adapter</tt> - An ActiveJob adapter. Default is the default ActiveJob adapter
      #
      # ==== Examples
      #
      #    # 'default' queue on the default adapter (ApplicationJob.queue_adapter or ActiveJob::Base.queue_adapter)
      #    ActiveJob::Query::Queue.new
      #    # queue for a specific adapter
      #    ActiveJob::Query::Queue.new(name: 'urgent', adapter: MyJob.queue_adapter)
      def initialize(name: 'default', adapter: nil)
        self.name = name
        self.adapter = adapter || default_adapter
      end

      # Returns a list of jobs.
      #
      # ==== Options
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
      #    queue = ActiveJob::Query::Queue.new
      #    queue.jobs
      #    queue.jobs(type: :scheduled)
      #    queue.jobs(type: :failed)
      #    queue.jobs(klass: PaymentsJob)
      #    queue.jobs(type: :failed, klass: PaymentsJob)
      def jobs(type: :all, klass: nil)
        ActiveJob::Query.jobs(queue: self, type: type, klass: klass)
      end

      # Returns the number of jobs on the queue with the type and klass filters applied.
      def size(type: :all, klass: nil)
        jobs(type: type, klass: klass).size
      end

      protected
        def default_adapter #:nodoc:
          defined?(ApplicationJob) ? ApplicationJob.queue_adapter : ActiveJob::Base.queue_adapter
        end
    end
  end
end
