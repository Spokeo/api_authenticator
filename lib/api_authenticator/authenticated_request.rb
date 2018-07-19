require 'openssl'
require 'active_support/security_utils' if defined?(ActiveSupport)

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
    valid_api_token?(originating_request(request), time, token)
  end

  protected

  def self.originating_request(request)
    if request_type == PATH_REQUEST_TYPE
      request.original_path
    else
      request.original_url
    end
  end

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
      if defined?(ActiveSupport)
         return true if ActiveSupport::SecurityUtils.secure_compare(expected_token, token)
      else
        return true if expected_token == token
      end
      keys_and_tokens << [secret_key, token, expected_token]
    end

    raise InvalidTokenError.new(time, keys_and_tokens)
  end
end
