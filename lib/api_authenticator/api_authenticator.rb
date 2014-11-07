require 'active_support/concern'
require 'digest'

module ApiAuthenticator
  extend ActiveSupport::Concern

  # Before filter
  def api_authenticator
    begin
      ApiAuthenticator.authenticated_request?(request)
    rescue BaseError => e
      report_unauthenticated_requests(e)
      render( status: 401, nothing: true ) and return false
    end
  end

  protected

  # TODO: more stuff in here
  def report_unauthenticated_requests(e)
    ApiAuthenticator.logger.warn("failed request #{e.constructed_message}")
  end

end