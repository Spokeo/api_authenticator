require 'active_support/core_ext'
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
    expected_token = OpenSSL::HMAC.hexdigest(digest, shared_secret_key, "#{time}#{request_url}")

    expected_token2 = Digest::SHA1.hexdigest("#{time}#{shared_secret_key}")

    unless [expected_token, expected_token2].include?(token)
      raise InvalidTokenError.new(time, shared_secret_key, expected_token, token)
    end
  end
end