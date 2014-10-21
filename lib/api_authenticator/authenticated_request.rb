module ApiAuthenticator
  # authenticated_request?
  #
  # Returns: True or False
  def self.authenticated_request?(request)
    time = request.headers['API-Time']
    token = request.headers['API-Token']

    valid_api_time?(time) && valid_api_token?(time, token)
  end

  protected

  def self.valid_api_time?(time)
    return false if time.nil?
    utc_now = Time.now.utc

    lower_threshold = utc_now - time_threshold
    upper_threshold = utc_now + time_threshold

    time >= lower_threshold && time <= upper_threshold
  end

  def self.valid_api_token?(time, token)
    Digest::SHA1.hexdigest("#{time}#{shared_secret_key}") == token
  end
end