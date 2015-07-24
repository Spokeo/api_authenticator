require 'spec_helper'
require 'active_support/core_ext'

describe 'ApiAuthenticator::Errors' do
  describe "InvalidTokenError" do
    it "should have a constructed_message" do
      error = ApiAuthenticator::InvalidTokenError.new(DateTime.now.utc, [[DateTime.now.utc, 'foobar', 'yolo']])
      expect(error.constructed_message).to match(/Invalid\sToken\sError/)
    end
  end
  describe "InvalidTimeError" do
    it "should have a constructed_message" do
      error = ApiAuthenticator::InvalidTimeError.new(DateTime.now.utc, DateTime.now.utc, DateTime.now.utc)
      expect(error.constructed_message).to match(/Invalid\sTime\sError/)
    end
  end
end