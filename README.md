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
| ip            | string                | `t.ip = '1.2.3.4'`                  | Customer IP address |
| city          | string                | `t.city = 'new york'`               | Customer city |
| state         | string                | `t.state = 'new york'`              | Customer state/province/region |
| postal        | string                | `t.postal = '10014'`                | Customer zip/postal code |
| country       | string                | `t.country = 'US'`                  | Customer ISO 3166-1 country code |

## Contributing

1. Fork it ( http://github.com/<my-github-username>/minfraud-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
