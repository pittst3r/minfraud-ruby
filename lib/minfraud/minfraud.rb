require "minfraud/version"

module Minfraud
  
  # May be used to configure using common block style:
  #
  # ```ruby
  # Minfraud.configure do |c|
  #   c.license_key = 'abcd1234'
  # end
  # ```
  #
  def self.configure
    yield self
  end

  # Module attribute getter for license_key
  # This is the MaxMind API consumer's license key.
  def self.license_key
    class_variable_defined?(:@@license_key) ? @@license_key : nil
  end

  # Module attribute setter for license_key
  # This is the MaxMind API consumer's license key.
  # It is required for this gem to work.
  def self.license_key=(key)
    @@license_key = key
  end

  # MaxMind minFraud API service URI
  def self.uri
    'https://minfraud.maxmind.com/app/ccv2r'
  end

end
