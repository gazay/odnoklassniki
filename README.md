# Odnoklassniki
[![Build Status](https://travis-ci.org/gazay/odnoklassniki.svg)](http://travis-ci.org/gazay/odnoklassniki) [![CodeClimate](https://d3s6mut3hikguw.cloudfront.net/github/gazay/odnoklassniki/badges/gpa.svg)](https://codeclimate.com/github/gazay/odnoklassniki)

**Odnoklassniki** is a Ruby wrapper for the [Odnoklassniki social network API](http://apiok.ru/).

At the moment, it is just a simple wrapper for GET and POST requests for Odnoklassniki API.

This gem is widely used by [Amplifr](https://amplifr.com/?utm_source=odnoklassniki-gem) social media management tool and is currently under development.

<a href="https://amplifr.com/?utm_source=odnoklassniki-gem">
<img src="https://amplifr.com/logo.png" alt="Amplifr" width="34" height="162">
</a>

<a href="https://evilmartians.com/?utm_source=odnoklassniki-gem">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54">
</a>

## Installation

You can install the gem via RubyGems:

```
gem install odnoklassniki
```

Or by using Bundler: put

```ruby
gem 'odnoklassniki'
```

in your `Gemfile`.

## Usage

To use Odnoklassniki API methods you should have "[VALUABLE ACCESS](http://apiok.ru/wiki/display/api/Authorization+OAuth+2.0)" to Odnoklassniki.

### Configuration

When using the gem with a Ruby on Rails application, you can configure Odnoklassniki globally by creating an initializer: `config/initializers/ok_api.rb`

```ruby
Odnoklassniki.configure do |c|
  c.application_key = 'You application key'
  c.client_id       = 'Your client id'
  c.client_secret   = 'Your client secret'
end
```

Or you can create a `Config` object and feed it to the `Odnoklassniki` module:

```ruby
config = Odnoklassniki::Config.configure do |c|
  # ...
end

Odnoklassniki.config = config
```

Also, when creating a new `Odnoklassniki::Client`, you can pass along all required (or missing from the configuration step) options right there:

```ruby
Odnoklassniki::Client.new(access_token: 'your token', client_id: 'your client id')
```

### Example

```ruby
client = Odnoklassniki::Client.new(access_token: token)

new_token = client.refresh_token! # This method will be called automatically just once
                                  # for each client before performing the request

client.get('friends.get')
client.get('friends/get')
client.get('api/friends/get')
client.get('/api/friends/get')
# NOTE: All GET requests above are identical!

client.post('mediatopic.post', type: 'USER_STATUS', attachment: attachment)
```

### Error Handling

Unfortunately, most errors from Odnoklassniki API are returned within a _success_ response (200 HTTP status code).
So, there is a wrapper just for that in this gem:

```ruby
begin
  client.get('some.wrong.request')
rescue Odnoklassniki::Error::ClientError => e
  e.inspect
end
```

Also there is a bunch of client/server error classes whose structure was gratefully copied and adopted from
[@sferik](https://github.com/sferik)'s [twitter](https://github.com/sferik/twitter) gem.
They can be useful in case when Odnoklassniki API wasn't reached at all or when some other issue has occured.

## TODO

1. Wrap some usual methods like `users.getCurrentUser`, `mediatopic.post` etc.
2. Write tests with real credentials

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Contributors

* @gazay

Special thanks to [@strech](https://github.com/strech), [@igas](https://github.com/igas).

## License

[The MIT License](https://github.com/gazay/odnoklassniki/blob/master/LICENSE)
