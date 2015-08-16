require 'sidekiq/api'

module ActiveJob
  module Query
    module Adapters
      module SidekiqAdapter extend self #:nodoc#
        def queues
          queues = Sidekiq::Queue.all.collect(&:name)
          queues += Sidekiq::ScheduledSet.new.map(&:itself).map(&:queue)
          queues.uniq
        end

        def enqueued_jobs(queue)
          jobs = []
          Sidekiq::Queue.new(queue).each do |job|
            next unless active_job_job?(job)
            jobs << wrap_job(job)
          end
          Sidekiq::RetrySet.new.each do |job|
            next unless active_job_job?(job)
            next unless job.queue == queue
            jobs << wrap_job(job)
          end
          jobs
        end

        def scheduled_jobs(queue)
          jobs = []
          Sidekiq::ScheduledSet.new.each do |job|
            next unless active_job_job?(job)
            next unless job.queue == queue
            jobs << wrap_job(job)
          end
          jobs
        end

        def failed_jobs(queue)
          jobs = []
          Sidekiq::DeadSet.new.each do |job|
            next unless active_job_job?(job)
            next unless job.queue == queue
            jobs << wrap_job(job)
          end
          jobs
        end

        def delete(job)
          sidekiq_job = job.provider_job || find_job(job.provider_job_id)
          sidekiq_job.delete if sidekiq_job.present?
        end

        protected
          def find_job(jid)

          end

          def wrap_job(job)
            aj = ActiveJob::Base.deserialize(job["args"].first)
            aj.send :deserialize_arguments_if_needed
            provider_job_id = aj.respond_to?(:provider_job_id) ? (aj.provider_job_id || job["jid"]) : job["jid"]
            Job.new(klass: aj.class, args: aj.arguments, job_id: aj.job_id, provider_job_id: provider_job_id, provider_job: self)
          end

          def active_job_job?(job)
            job.klass == "ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper"
          end
      end
    end
  end
end
