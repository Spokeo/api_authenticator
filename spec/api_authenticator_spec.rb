require 'spec_helper'
require 'openssl'

describe 'ApiAuthenticator' do
  let :shared_key do
    'asdf'
  end

  let :shared_key2 do
    'fork123'
  end

  let :api_token do
    digest = OpenSSL::Digest.new('sha256')
    OpenSSL::HMAC.hexdigest(digest, shared_key, "#{DateTime.now.new_offset(0)}http://www.austinrocks.com/asdf")
  end

  let :api_token_from_request do
    digest = OpenSSL::Digest.new('sha256')
    OpenSSL::HMAC.hexdigest(digest, shared_key, "#{DateTime.now.new_offset(0)}/asdf")
  end

  let :valid_request do
    time = DateTime.now.utc
    double(:request, original_path: "/asdf", original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => api_token})
  end

  let :valid_request_with_path do
    time = DateTime.now.utc
    double(:request, original_path: "/asdf", original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => api_token_from_request})
  end

  let :api_token2 do
    digest = OpenSSL::Digest.new('sha256')
    OpenSSL::HMAC.hexdigest(digest, shared_key2, "#{DateTime.now.new_offset(0)}http://www.austinrocks.com/asdf")
  end

  let :valid_request_shared_key2 do
    time = DateTime.now.utc
    double(:request, original_path: "/asdf", original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => api_token})
  end

  let :bad_time_request do
    time = 6.years.from_now
    double(:request, original_path: "/asdf", original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => api_token})
  end

  let :bad_token_request do
    time = Time.now.utc
    double(:request, original_path: "/asdf", original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => "AUSTIN LIVES IN YO TESTS"})
  end



  context "authenticated_request?" do
    before :each do
      ApiAuthenticator.configure do |config|
        config.time_threshold = 2.hours
        request_type = :url
        config.shared_secret_keys = [shared_key, shared_key2]
      end
    end
    context "authenticated_request? with request path" do
      it "should be a valid request" do
        ApiAuthenticator.request_type = :path
        expect{ApiAuthenticator.authenticated_request?(valid_request_with_path)}.to_not raise_error
        ApiAuthenticator.request_type = :url
      end
    end

    context 'valid_request' do
      it "should not throw an exception" do
        expect{ApiAuthenticator.authenticated_request?(valid_request)}.to_not raise_error
      end

      it "should not throw an exception with shared_key2" do
        expect{ApiAuthenticator.authenticated_request?(valid_request_shared_key2)}.to_not raise_error
      end
    end

    context "passing a request dependent on URL but putting a path" do
      it "should throw an exception" do
        expect{ApiAuthenticator.authenticated_request?(valid_request_with_path)}.to raise_error(ApiAuthenticator::InvalidTokenError)
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
