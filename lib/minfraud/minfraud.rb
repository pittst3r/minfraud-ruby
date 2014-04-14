require "minfraud/version"

module Minfraud

  class ConfigurationError < ArgumentError; end
  
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
    unless has_required_configuration?
      raise ConfigurationError, 'You must set license_key so MaxMind can identify you'
    end
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

  def self.has_required_configuration?
    class_variable_defined?(:@@license_key)
  end

end
