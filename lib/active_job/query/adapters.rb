module ActiveJob
  module Query
    module Adapters
      extend ActiveSupport::Autoload

      autoload :SidekiqAdapter
    end
  end
end
