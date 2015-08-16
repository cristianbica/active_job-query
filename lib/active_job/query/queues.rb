module ActiveJob
  module Query
    # = ActiveJob Queues
    #
    # Holds a collection of ActiveJob queues. Responds to all
    # Enumerable methods.
    #
    # Usage:
    #
    #   ActiveJob::Query::Queues.new.each do |queue|
    #     # queue is an instance of ActiveJob::Query::Queue
    #   end
    class Queues
      attr_accessor :queues, :adapter
      include Enumerable
      delegate *Enumerable.public_instance_methods, to: :queues

      # Returns a collection of queues an adapter is aware of.
      #
      # ==== Options
      # * <tt>:adapter</tt> - An ActiveJob adapter. Default is the default ActiveJob adapter
      #
      # ==== Examples
      #
      #    # queues for the default adapter (ApplicationJob.queue_adapter or ActiveJob::Base.queue_adapter)
      #    ActiveJob::Query::Queues.new
      #    # queues for a specific adapter
      #    ActiveJob::Query::Queues.new(adapter: MyJob.queue_adapter)
      def initialize(adapter: nil)
        self.adapter = adapter || default_adapter
      end

      def queues #:nodoc:
        @queues ||= query_adapter.queues.map do |name|
          Queue.new(name: name, adapter: adapter)
        end
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
