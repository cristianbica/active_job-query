ApplicationJob.queue_adapter = ENV['AJADAPTER']

case ENV['AJADAPTER']
when 'sidekiq'
  ENV['REDIS_URL'] ||= "redis://localhost:6379/1"
  Sidekiq.configure_server do |config|
    config.redis = { url: ENV['REDIS_URL'], namespace: 'aj-query-tests' }
  end
  Sidekiq.configure_client do |config|
    config.redis = { url: ENV['REDIS_URL'], namespace: 'aj-query-tests' }
  end
end
