module ApiAuthenticator
  @@logger = nil
  URL_REQUEST_TYPE = :url
  PATH_REQUEST_TYPE = :path
  @@request_type = URL_REQUEST_TYPE
  REQUEST_TYPES = [URL_REQUEST_TYPE, PATH_REQUEST_TYPE]

  def self.configure
    yield self
  end

  def self.shared_secret_keys=(shared_secret_keys)
    @@shared_secret_keys = shared_secret_keys
  end

  def self.shared_secret_keys
    @@shared_secret_keys
  end

  def self.request_type
    @@request_type
  end

  def self.request_type=(request_type)
    unless REQUEST_TYPES.include?(request_type)
      raise ArgumentError.new("Request types must be one of the following #{REQUEST_TYPES.join(', ')}}")
    end
    @@request_type = request_type
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
