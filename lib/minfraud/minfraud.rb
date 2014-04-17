module Minfraud

  class ConfigurationError < ArgumentError; end
  class TransactionError < ArgumentError; end
  class ResponseError < ArgumentError; end
  
  # May be used to configure using common block style:
  #
  # ```ruby
  # Minfraud.configure do |c|
  #   c.license_key = 'abcd1234'
  # end
  # ```
  #
  # @param [Proc] is passed the Minfraud module as its argument
  # @return [nil, ConfigurationError]
  def self.configure
    yield self
    unless has_required_configuration?
      raise ConfigurationError, 'You must set license_key so MaxMind can identify you'
    end
  end

  # Module attribute getter for license_key
  # This is the MaxMind API consumer's license key.
  # @return [String, nil] license key if set
  def self.license_key
    class_variable_defined?(:@@license_key) ? @@license_key : nil
  end

  # Module attribute setter for license_key
  # This is the MaxMind API consumer's license key.
  # It is required for this gem to work.
  # @param key [String] license key
  # @return [String] license key
  def self.license_key=(key)
    @@license_key = key
  end

  # Module attribute getter for requested_type
  # minFraud service level (standard/premium)
  # @return [String, nil] service level if set
  def self.requested_type
    class_variable_defined?(:@@requested_type) ? @@requested_type : nil
  end

  # Module attribute setter for requested_type
  # Desired service level (standard/premium)
  # @param type [String] service level
  # @return [String] service level
  def self.requested_type=(type)
    @@requested_type = type
  end

  # MaxMind minFraud API service URI
  # @return [URI::HTTPS] service uri
  def self.uri
    @@uri ||= URI('https://minfraud.maxmind.com/app/ccv2r')
  end

  # @return [Boolean] service URI
  def self.has_required_configuration?
    class_variable_defined?(:@@license_key)
  end

end
