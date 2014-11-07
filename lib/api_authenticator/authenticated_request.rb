require 'active_support/core_ext'

module ApiAuthenticator
  # authenticated_request?
  #
  # Returns: True or False
  def self.authenticated_request?(request)
    time = nil
    token = request.headers['API-Token']
    begin
      time = DateTime.parse(request.headers['API-Time'])
    rescue ArgumentError
    end
    valid_api_time?(time)
    valid_api_token?(time, token)
  end

  protected

  def self.valid_api_time?(time)
    return false if time.nil?
    utc_now = DateTime.now.new_offset(0)

    lower_threshold = utc_now - time_threshold
    upper_threshold = utc_now + time_threshold

    if time < lower_threshold || time > upper_threshold
      raise InvalidTimeError.new(upper_threshold, lower_threshold, time)
    end
  end

  def self.valid_api_token?(time, token)
    expected_token = Digest::SHA1.hexdigest("#{time}#{shared_secret_key}")
    unless expected_token == token
      raise InvalidTokenError.new(time, shared_secret_key, expected_token, token)
    end
  end
end