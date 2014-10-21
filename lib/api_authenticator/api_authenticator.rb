require 'active_support/concern'
require 'digest'

module ApiAuthenticator
  extend ActiveSupport::Concern

  module InstanceMethods
    # Before filter
    def api_authenticator
      unless ApiAuthenticator.authenticated_request?(request)
        report_unauthenticated_requests
        render( status: 401, nothing: true ) and return false
      end
    end

    # TODO: more stuff in here
    def report_unauthenticated_requests
      logger.warn("failed request")
    end
  end
end