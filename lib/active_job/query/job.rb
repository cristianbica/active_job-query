module ActiveJob
  module Query
    # = ActiveJob Job
    #
    # Hold the details of a job.
    #
    # Usage:
    #
    #    queue = ActiveJob::Query::Queue.new
    #    job = queue.jobs.first
    #    job.delete
    #    job.active_job.perform_now
    class Job
      attr_accessor :queue, :adapter, :klass, :args, :job_id, :provider_job_id, :provider_job

      def initialize(queue: nil, adapter: nil, klass:, args: [], job_id:, provider_job_id: nil, provider_job: nil) #:nodoc#
        self.queue = queue
        self.adapter = adapter || default_adapter
        self.klass = klass
        self.args = args
        self.job_id = job_id
        self.provider_job_id = provider_job_id
        self.provider_job = provider_job
      end

      # Finds a job on a specified queue or on all queues of an adapter by job_id or provider_job_id
      # WARINING: for big queues this will take a while
      def find_job(queue: nil, adapter: nil, job_id: nil, provider_job_id: nil)
        raise ArgumentError, "You must provide a queue or an adapter" unless queue.present? or adapter.present?
        raise ArgumentError, "You must provide a job_id or a provider_job_id" unless job_id.present? or provider_job_id.present?
        queues = if queue.present?
          [queue]
        else
          ActiveJob::Query.queues(adapter)
        end
        queues.each do |q|
          q.jobs.each do |job|
            return job if job_id.present? and job.job_id == job_id
            return job if provider_job_id.present? and job.provider_job_id == provider_job_id
          end
        end
      end

      # Permanently deletes the job from the queue
      def delete
        query_adapter.delete(self)
      end

      # Returns an ActiveJob::Base subclass instnace
      def active_job
        job = klass.new
        job.queue_name = queue.name
        job.job_id = job_id
        job.provider_job_id = provider_job_id if job.respond_to?(:provider_job_id=)
        job.arguments = args
        job
      end

      protected
        def default_adapter #:nodoc:
          defined?(ApplicationJob) ? ApplicationJob.queue_adapter : ActiveJob::Base.queue_adapter
        end

        def query_adapter #:nodoc:
          @query_adapter ||= ActiveJob::Query.query_adapter(adapter)
        end
    end
  end
end
