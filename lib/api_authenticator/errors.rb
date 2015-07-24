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
    attr_reader :time, :keys_and_tokens

    def initialize(time, keys_and_tokens)
      @time = time
      @keys_and_tokens = keys_and_tokens
    end


    def constructed_message
      message = ""
      @keys_and_tokens.each do |key_and_token|
        message << "Invalid Token Error Time: #{@time} Shared Key: #{key_and_token[0]} expected token: #{key_and_token[2]} actual token: #{key_and_token[1]}"
      end
      message
    end
  end
end