module ActiveJob
  module Query
    # = ActiveJob Query
    #
    # This externs ActiveJob::Base with two methods: queues and jobs:
    # queues: returns the queue the job's adapter is aware of
    # jobs: returns all the enqueued jobs of this class
    module Mixin
      extend ActiveSupport::Concern

      module ClassMethods
        # Returns a list of queues the adapter is aware of.
        #
        # ==== Returns
        # * <tt>ActiveJob::Query::Queues</tt> - A collection of queues.
        def queues
          ActiveJob::Query::Queues.new(adapter: queue_adapter)
        end

        # Returns a list of jobs for this class.
        #
        # ==== Options
        # * <tt>:queue_name</tt> - A queue name. Default is 'default'
        # * <tt>:type</tt> - The type of the job:
        #   - all - All jobs
        #   - enqueued - Enqueued jobs that will be run asap
        #   - scheduled - Jobs scheduled to run in the future
        #   - failed - Jobs that failed and that will never be executed again
        #
        # ==== Returns
        # * <tt>ActiveJob::Query::Jobs</tt> - A collection of jobs.
        #
        # ==== Examples
        #
        #    # jobs enqueued
        #    MyJob.jobs(type: :enqueued)
        #    # all jobs on specified queue
        #    MyJob.jobs(queue_name: 'urgent')
        def jobs(queue_name: 'default', type: :all)
          ActiveJob::Query::Jobs.new(queue_name: queue_name, type: :all, klass: self)
        end
      end
    end
  end
end
