require 'global_id/railtie'
require 'active_job'

module ActiveJob
  module Query
    class Railtie < Rails::Railtie
      ActiveSupport.on_load(:active_job) do
        include ActiveJob::Query::Mixin
      end
    end
  end
end
