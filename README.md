# ActiveJob::Query

WARINING: This is alpha level release. Use it for testing only! (or if you want to contribute :) )

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/active_job/query`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake false` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/active_job-query.

