module ApiAuthenticator
  class BaseError < StandardError
  end

  class InvalidTimeError < BaseError
    attr_reader :upper_threshold, :lower_threshold, :actual_time

    def initialize(upper_threshold, lower_threshold, actual_time)
      @upper_threshold = upper_threshold
      @lower_threshold = lower_threshold
      @actual_time = actual_time
    end

    def constructed_message
      "Invalid Time Error: upper threshold: #{@upper_threshold} lower threshold: #{@lower_threshold} actual time: #{@actual_time}"
    end
  end

  class InvalidTokenError < BaseError
    attr_reader :time, :shared_secret_key, :expected_token, :actual_token

    def initialize(time, shared_secret_key, expected_token, actual_token)
      @time = time
      @shared_secret_key = shared_secret_key
      @expected_token = expected_token
      @actual_token = actual_token
    end


    def constructed_message
      "Invalid Token Error Time: #{@time} Shared Key: #{@shared_secret_key} expected token: #{@expected_token} actual token: #{@actual_token}"
    end
  end
end