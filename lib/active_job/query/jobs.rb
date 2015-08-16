module ActiveJob
  module Query
    # = ActiveJob Jobs
    #
    # Holds a collection of ActiveJob jobs. Responds to all
    # Enumerable methods.
    #
    # Usage:
    #
    #   ActiveJob::Query::Jobs.new.each do |jobs|
    #     # job is an instance of ActiveJob::Query::Job
    #   end
    class Jobs
      attr_accessor :jobs, :queue, :adapter, :type, :klass
      include Enumerable
      delegate *Enumerable.public_instance_methods, to: :jobs
      alias :size :count

      # Returns a collection of jobs.
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
      #    ActiveJob::Query::Jobs.new
      #    # jobs on a named queue, on the default adapter
      #    ActiveJob::Query::Jobs.new(queue_name: 'urgent')
      #    # jobs on a named queue, on a specific adapter
      #    ActiveJob::Query::Jobs.new(queue_name: 'urgent', adapter: MyJob.queue_adapter)
      #    # jobs on a queue
      #    ActiveJob::Query::Jobs.new(queue: ActiveJob::Query::Queue.new(name: 'urgent', adapter: MyJob.queue_adapter))
      def initialize(queue: nil, queue_name: nil, adapter: nil, type: :all, klass: nil)
        if queue and queue.is_a?(Queue)
          self.queue = queue
          self.adapter = queue.adapter
        elsif queue_name
          self.adapter = adapter || default_adapter
          self.queue = Queue.new(name: "default", adapter: self.adapter)
        end
        raise ArgumentError, "You must provide a queue or a queue_name" unless self.queue
        self.type = type
        self.klass = klass
      end

      # Deletes all jobs from this collection.
      # WARNING: This will delete the jobs permanently
      def delete_all
        jobs.map(&:delete)
      end

      def jobs #:nodoc:
        @jobs ||= begin
          jobs = (fetch_jobs(:enqueued) + fetch_jobs(:scheduled) + fetch_jobs(:failed))
          jobs.select! do |job|
            job.klass == klass
          end if klass.present?
          jobs
        end
      end

      protected
        def includes_enqueued_jobs? #:nodoc:
          type.to_s == 'all' or type.to_s == 'enqueued'
        end

        def includes_scheduled_jobs? #:nodoc:
          type.to_s == 'all' or type.to_s == 'scheduled'
        end

        def includes_failed_jobs? #:nodoc:
          type.to_s == 'all' or type.to_s == 'failed'
        end

        def fetch_jobs(job_type) #:nodoc:
          return [] unless send(:"includes_#{job_type}_jobs?")
          query_adapter.send(:"#{job_type}_jobs", queue.name).each do |job|
            job.adapter = adapter
            job.queue   = queue
          end
        end

        def default_adapter #:nodoc:
          defined?(ApplicationJob) ? ApplicationJob.queue_adapter : ActiveJob::Base.queue_adapter
        end

        def query_adapter #:nodoc:
          @query_adapter ||= ActiveJob::Query.query_adapter(adapter)
        end
    end
  end
end
