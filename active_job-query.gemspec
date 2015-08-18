# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_job/query/version'

Gem::Specification.new do |spec|
  spec.name          = "active_job-query"
  spec.version       = ActiveJob::Query::VERSION
  spec.authors       = ["Cristian Bica"]
  spec.email         = ["cristian.bica@gmail.com"]

  spec.summary       = %q{ActiveJob query interface.}
  spec.description   = %q{ActiveJob::Query allows you query enqueued jobs and cancel jobs.}
  spec.homepage      = "https://github.com/cristianbica/active_job-query"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activejob'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
