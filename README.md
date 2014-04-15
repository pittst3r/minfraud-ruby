# Ruby interface to the MaxMind minFraud API

[![Code Climate](https://codeclimate.com/github/rdpitts/minfraud-ruby.png)](https://codeclimate.com/github/rdpitts/minfraud-ruby)

[Complete API documentation](http://rubydoc.info/github/rdpitts/minfraud-ruby/master/frames)

## Configuration

Your license key is how MaxMind will identify you, so it is required.

```ruby
Minfraud.configure do |c|
  c.license_key = 'abcd1234'
end
```

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

### Transaction fields

#### Required

| name          | type (length)         | example                             | description |
| ------------- | --------------------- | ----------------------------------- | ----------- |
| ip            | string                | `t.ip = '1.2.3.4'`                  | The IP address of the customer placing the order. This should be passed as a string like "44.55.66.77" or "2001:db8::2:1". |

#### Optional

| name          | type (length)         | example                             | description |
| ------------- | --------------------- | ----------------------------------- | ----------- |
| ship_addr     | string                | `t.ship_addr = '123 fake st'`       | The IP address of the customer placing the order. This should be passed as a string like "44.55.66.77" or "2001:db8::2:1". |

## Contributing

1. Fork it ( http://github.com/<my-github-username>/minfraud-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
