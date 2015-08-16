class FirstJob < ApplicationJob
  queue_as :default

  def perform(what=nil)
    raise "fail" if what=='fail'
  end
end
