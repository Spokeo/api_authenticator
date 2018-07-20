require 'spec_helper'

describe "ApiAuthenticator configuration" do
  it "by default request type should be URL" do
    expect(ApiAuthenticator.request_type).to eql(ApiAuthenticator::URL_REQUEST_TYPE)
  end

  it "can assign request type to :path" do
    ApiAuthenticator.request_type = ApiAuthenticator::PATH_REQUEST_TYPE
    expect(ApiAuthenticator.request_type).to eql(ApiAuthenticator::PATH_REQUEST_TYPE)
  end

  it "should throw an ArgumentError if request_type isn't acceptable" do
    expect do
      ApiAuthenticator.request_type = 'foo'
    end.to raise_error(ArgumentError)
  end
end
