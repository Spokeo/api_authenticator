# ApiAuthenticator

[![Code Climate](https://codeclimate.com/github/Spokeo/api_authenticator/badges/gpa.svg)](https://codeclimate.com/github/Spokeo/api_authenticator)
[![Build Status](https://travis-ci.org/Spokeo/api_authenticator.svg)](https://travis-ci.org/Spokeo/api_authenticator)

This gem will authenticate API requests using a slightly modified version HMAC-SHA1

## Installation

Add this line to your application's Gemfile:

    gem 'api_authenticator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api_authenticator

## Authentication

This gem assumes headers being pass into the request.
The two headers are:
 - API-Time
 - API-Token

### API-Time
The API-Time is a String UTC representation of the current time of request.

For example:

```ruby
=> "2014-10-16 18:55:48 UTC"
```

### API-Token
The token passed in is a SHA256 of the time AND the request URL.  The shared_secret_key is used as the encyrption key.

```ruby
digest = OpenSSL::Digest.new('sha256')

env['API-Token'] = OpenSSL::HMAC.hexdigest(digest, shared_secret_key, "#{DateTime.now.new_offset(0)}#{request.original_url}")
```


## Configuration

```ruby
ApiAuthenticator.configure do |config|
  config.shared_secret_key = "my_shared_token"
  config.time_threshold = 2.hours
  config.logger = Rails.logger
  config.report_unauthenticated_requests = true
end
```

 - shared_secret_key: The shared secret key between the client and the server.
 - time_threshold: The time threshold to allow requests.  So for example the entry above will only allow requests from 2 hours before now and 2 hours in the future.
 - logger: Your logger
 - report_unauthenticated_requests: will throw some basic information into your logger.warn.

## Usage
 There is a before_filter that is included in the gem.  If not authenticated it will automatically render a status 401.

```ruby
class ApiController
  include ApiAuthenticator

  before_filter :api_authenticator
end
```

Or you can use it without the before_filter.
Note here is that right now, if the request is not authenticated the gem with throw an exception.  All exceptions inherit from ApiAuthentiactor::BaseError

```ruby
class ApiController
  def people
    # Takes a Rails request object
    begin
      ApiAuthentiactor.authenticated_request?(request)
    rescue ApiAuthenticator::InvalidTimeError => e
      logger.error(e)
    rescue ApiAuthenticator::InvalidTokenError => e
      logger.error(e)
    end
  end
end
```


## TODO:
- Set time intervals instead of explicity passing in the time.

## Running The Specs

Just run rake:
```
rake
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/api_authenticator/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
