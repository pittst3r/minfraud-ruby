# Ruby interface to the MaxMind minFraud API

Compatible with version minFraud API v1.3  
[minFraud API documentation](http://dev.maxmind.com/minfraud/)  
[minFraud](http://www.maxmind.com/en/ccv_overview)

[![Build Status](https://travis-ci.org/rdpitts/minfraud-ruby.svg?branch=master)](https://travis-ci.org/rdpitts/minfraud-ruby)
[![Code Climate](https://codeclimate.com/github/rdpitts/minfraud-ruby.png)](https://codeclimate.com/github/rdpitts/minfraud-ruby)

[Rubydoc documentation](http://rubydoc.info/github/rdpitts/minfraud-ruby/master/frames)

## Configuration

Your license key is how MaxMind will identify you, so it is required.

```ruby
Minfraud.configure do |c|
  c.license_key = 'abcd1234'
  c.requested_type = 'standard'
end
```

`requested_type` can be set during configuration to use that default value or it can be set on the transaction. If unset minFraud will default to the highest level of service available to you.

## Usage

```ruby
transaction = Minfraud::Transaction.new do |t|
  # Required fields
  # Other fields listed later in documentation are optional
  t.ip = '1.2.3.4'
  t.city = 'richmond'
  t.state = 'virginia'
  t.postal = '12345'
  t.country = 'US' # http://en.wikipedia.org/wiki/ISO_3166-1
  # ...
end

transaction.risk_score
# => 3.48
```

### Exception handling

There are three different exceptions that this gem may raise. Please be prepared to handle them:

```ruby
# Raised if configuration is invalid
class ConfigurationError < ArgumentError; end

# Raised if a transaction is invalid
class TransactionError < ArgumentError; end

# Raised if minFraud returns an error, or if there is an HTTP error
class ResponseError < ArgumentError; end
```

### Transaction fields

#### Required

| name          | type (length)         | example                             | description |
| ------------- | --------------------- | ----------------------------------- | ----------- |
| ip            | string                | `t.ip = '1.2.3.4'`                  | Customer IP address |
| city          | string                | `t.city = 'new york'`               | Customer city |
| state         | string                | `t.state = 'new york'`              | Customer state/province/region |
| postal        | string                | `t.postal = '10014'`                | Customer zip/postal code |
| country       | string                | `t.country = 'US'`                  | Customer ISO 3166-1 country code |

#### Optional

| name               | type (length)      | description |
| ------------------ | ------------------ | ----------- |
| ship_addr          | string             | |
| ship_city          | string             | |
| ship_state         | string             | |
| ship_postal        | string             | |
| ship_country       | string             | |
| email              | string             | We will hash the email for you |
| phone              | string             | Any format acceptable |
| bin                | string             | CC bin number (first 6 digits) |
| session_id         | string             | Used for linking transactions |
| user_agent         | string             | Used for linking transactions |
| accept_language    | string             | Used for linking transactions |
| txn_id             | string             | Transaction/order id |
| amount             | string             | Transaction amount |
| currency           | string             | ISO 4217 currency code |
| txn_type           | string             | creditcard/debitcard/paypal/google/other/lead/survey/sitereg |
| avs_result         | string             | Standard AVS response code |
| cvv_result         | string             | Y/N |
| requested_type     | string             | standard/premium |
| forwarded_ip       | string             | The end user’s IP address, as forwarded by a transparent proxy |

## Contributing

1. Fork it ( http://github.com/<my-github-username>/minfraud-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
