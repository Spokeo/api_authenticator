require 'spec_helper'
require 'active_support'

class TesterTemper
  include ApiAuthenticator

  attr_reader :request

  def initialize(request)
    @request = request
  end
end

describe "ApiAuthenticator Concern" do
  before :each do
    ApiAuthenticator.configure do |config|
      config.time_threshold = 2.hours
      config.shared_secret_key = shared_key
    end
  end

  let :shared_key do
    'asdf'
  end

  let :bad_time_request do
    time = 6.years.from_now
    double(:request, original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => Digest::SHA1.hexdigest("#{time}#{shared_key}")})
  end

  let :bad_token_request do
    time = Time.now.utc
    double(:request, original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => "AUSTIN LIVES IN YO TESTS"})
  end
  let :api_token do
    digest = OpenSSL::Digest.new('sha256')
    OpenSSL::HMAC.hexdigest(digest, shared_key, "#{DateTime.now.new_offset(0)}http://www.austinrocks.com/asdf")
  end

  let :valid_request do
    time = DateTime.now.utc
    double(:request, original_url: "http://www.austinrocks.com/asdf", headers: {"API-Time" => time.to_s, "API-Token" => api_token})
  end

  describe "api_authenticator" do
    context 'successful requests' do
      it "should not return false if authenticated_request" do
        temp_class = TesterTemper.new(valid_request)
        # expect(temp_class).to receive(:render) { }
        expect(temp_class.api_authenticator).to be_nil
      end
    end

    context 'invalid token requests' do
      it "should return false and render" do
        temp_class = TesterTemper.new(bad_token_request)
        expect(temp_class).to receive(:render) { }
        expect(temp_class.api_authenticator).to be_falsey
      end
    end

    context 'invalid time requests' do
      it "should return false and render" do
        temp_class = TesterTemper.new(bad_time_request)
        expect(temp_class).to receive(:render) { }
        expect(temp_class.api_authenticator).to be_falsey
      end
    end
  end
end