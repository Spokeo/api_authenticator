require 'spec_helper'
require 'openssl'
require 'active_support/core_ext'

describe 'ApiAuthenticator' do
  let :shared_key do
    'asdf'
  end

  let :api_token do
    digest = OpenSSL::Digest.new('sha256')
    OpenSSL::HMAC.hexdigest(digest, shared_key, "#{DateTime.now.new_offset(0)}http://www.austinrocks.com/asdf")
  end

  let :valid_request_backwards_compatible do
    time = DateTime.now.utc
    double(:request, original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => Digest::SHA1.hexdigest("#{time}#{shared_key}")})
  end

  let :valid_request do
    time = DateTime.now.utc
    double(:request, original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => api_token})
  end

  let :bad_time_request do
    time = 6.years.from_now
    double(:request, original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => api_token})
  end

  let :bad_token_request do
    time = Time.now.utc
    double(:request, original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => "AUSTIN LIVES IN YO TESTS"})
  end

  context "authenticated_request?" do
    before :each do
      ApiAuthenticator.configure do |config|
        config.time_threshold = 2.hours
        config.shared_secret_key = shared_key
      end
    end

    context 'backwards compatibability' do
      it "should not throw an exception" do
        expect{ApiAuthenticator.authenticated_request?(valid_request_backwards_compatible)}.to_not raise_error
      end
    end


    context 'valid_request' do
      it "should not throw an exception" do
        expect{ApiAuthenticator.authenticated_request?(valid_request)}.to_not raise_error
      end
    end

    context 'invalid time' do
      it "should raise InvalidTimeError" do
        expect{ApiAuthenticator.authenticated_request?(bad_time_request)}.to raise_error(ApiAuthenticator::InvalidTimeError)
      end
    end

    context 'bad api token' do
      it "should raise InvalidTokenError" do
        expect{ApiAuthenticator.authenticated_request?(bad_token_request)}.to raise_error(ApiAuthenticator::InvalidTokenError)
      end
    end
  end
end