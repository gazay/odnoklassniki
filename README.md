# Odnoklassniki
[![Build Status](https://travis-ci.org/gazay/odnoklassniki.svg)](http://travis-ci.org/gazay/odnoklassniki) [![CodeClimate](https://d3s6mut3hikguw.cloudfront.net/github/gazay/odnoklassniki/badges/gpa.svg)](https://codeclimate.com/github/gazay/odnoklassniki)

Ruby wrapper for Odnoklassniki API

Right now it is a simple wrapper on get and post requests to Odnoklassniki api.

<a href="https://evilmartians.com/?utm_source=odnoklassniki-gem">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54">
</a>

## Installation

```
    gem install odnoklassniki
```

## Usage

To use odnoklassniki api methods you should have [VALUABLE ACCESS](http://dev.odnoklassniki.ru/wiki/pages/viewpage.action?pageId=12878032) to odnoklassniki.

### Configuration

You can create global configuration for your application. Create initializer `config/initializers/ok_api.rb`:

```ruby
Odnoklassniki.configure do |c|
  c.application_key = 'You application key'
  c.client_id       = 'Your client id'
  c.client_secret   = 'Your client secret'
end
```

Or you can create config object and feed it to `Odnoklassniki` module:

```ruby
config = Odnoklassniki::Config.configure do |c|
  ...
end

Odnoklassniki.config = config
```

Also, when you create new `Odnoklassniki::Client` you can pass all needed (or missed on configuration step) options right there:

```ruby
Odnoklassniki::Client.new(access_token: 'your token', client_id: 'your client id')
```

### Example

```ruby
client = Odnoklassniki::Client.new(access_token: token)

new_token = client.refresh_token! # This method will be called automaticaly just once
                                  # for each client before performing request

client.get('friends.get')
client.get('friends/get')
client.get('api/friends/get')
client.get('/api/friends/get')
# All get requests above identical

client.post('mediatopic.post', type: 'USER_STATUS', attachment: attachment)
```

### Error handling

Most of errors from Odnoklassniki API retruned in success response (with status code 200).
So there is a wrapper for it in this gem:

```ruby
begin
  client.get('some.wrong.request')
rescue Odnoklassniki::Error::ClientError => e
  e.inspect
end
```

Also there are bunch of client/server error classes which structure was gratefully copied and adopted from
@sferik's twitter gem. They can be useful when Odnoklassniki API wasn't reached or when some other issue occured.

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

Special thanks to @Strech, @igas.

## License

The MIT License
