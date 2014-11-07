module ApiAuthenticator
  @@logger = nil

  def self.configure
    yield self
  end

  def self.shared_secret_key=(shared_secret_key)
    @@shared_secret_key = shared_secret_key
  end

  def self.shared_secret_key
    @@shared_secret_key
  end

  def self.time_threshold=(time_threshold)
    @@time_threshold = time_threshold
  end

  def self.time_threshold
    @@time_threshold
  end

  def self.report_unauthenticated_requests=(report)
    @@report_unauthenticated_requests = report || false
  end

  def self.logger=(logger)
    @@logger = logger || Logger.new($stdout)
  end

  def self.logger
    @@logger || Logger.new($stdout)
  end
end