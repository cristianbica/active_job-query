class ApplicationJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    raise NotImplementedError
  end
end
