# ActiveJob::Query

WARINING: This is alpha level release. Use it for testing only! (or if you want to contribute :) )

ActiveJob::Query is an wrapper around queueing adapter jobs query interface. It allows you to fetch jobs and manipulate the jobs.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_job-query'
```

And then execute:

    $ bundle

## Usage

Fetching all queues that the adapter is aware of
```ruby
  # On the default adapter (ApplicationJob.queue_adapter or ActiveJob::Base.queue_adapter)
  ActiveJob::Query.queues
  # Or on a specific adapter
  ActiveJob::Query.queues(adapter: MyJob.queue_adapter)
  # or
  MyJob.queues
```

Working with queues
```ruby
  # Get a queue
  queue = ActiveJob::Query.queues.first
  # Or initialize directly
  queue = ActiveJob::Query::Queue.new(name: "default", adapter: ActiveJob::Base.queue_adapter)
  # jobs count
  queue.size
  # clear jobs
  queue.delete_all
  # fetch jobs
  queue.jobs

```

Fetching jobs
```ruby
  ActiveJob::Query.jobs(
    type: :all # allowed values: :all || :pending || :scheduled || :failed
    queue: "default", # queue name to search on
    adapter: AJ adapter defaults to ActiveJob::Base.queue_adapter
  )
```

Fetching all jobs on a specific queue
```ruby
  ActiveJob::Query.queues[0].jobs
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cristianbica/active_job-query.

