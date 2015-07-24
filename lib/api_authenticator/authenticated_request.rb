require 'openssl'

module ApiAuthenticator
  # authenticated_request?
  #
  # Returns: True or False
  def self.authenticated_request?(request)
    time = nil
    token = request.headers['API-Token']
    begin
      time = DateTime.parse(request.headers['API-Time'])
    rescue ArgumentError, TypeError
    end
    valid_api_time?(time)
    valid_api_token?(request.original_url, time, token)
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

  def self.valid_api_token?(request_url, time, token)
    digest = OpenSSL::Digest.new('sha256')
    keys_and_tokens = []
    shared_secret_keys.each do |secret_key|
      expected_token = OpenSSL::HMAC.hexdigest(digest, secret_key, "#{time}#{request_url}")
      return true if expected_token == token
      keys_and_tokens << [secret_key, token, expected_token]
    end

    raise InvalidTokenError.new(time, keys_and_tokens)
  end
end