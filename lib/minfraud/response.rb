module Minfraud

  # This class wraps the raw minFraud response. Any minFraud response field is accessible on a Response
  # instance as a snake-cased instance method. For example, if you want the `ip_corporateProxy`
  # field from minFraud, you can get it with `#ip_corporate_proxy`.
  class Response

    ERROR_CODES = %w( INVALID_LICENSE_KEY IP_REQUIRED LICENSE_REQUIRED COUNTRY_REQUIRED MAX_REQUESTS_REACHED )
    WARNING_CODES = %w( IP_NOT_FOUND COUNTRY_NOT_FOUND CITY_NOT_FOUND CITY_REQUIRED POSTAL_CODE_REQUIRED POSTAL_CODE_NOT_FOUND )

    # Sets attributes on self using minFraud response keys and values
    # Raises an exception if minFraud returns an error message
    # Does nothing (at the moment) if minFraud returns a warning message
    # Raises an exception if minFraud responds with anything other than an HTTP success code
    # @param raw [Net::HTTPResponse]
    def initialize(raw)
      raise ResponseError, "The minFraud service responded with http error #{raw.class}" unless raw.is_a? Net::HTTPSuccess
      decode_body(raw.body)
      raise ResponseError, "Error message from minFraud: #{error}" if errored?
    end

    private

    # True if minFraud returns an error (but not a warning), false if not.
    # @return [Boolean]
    def errored?
      ERROR_CODES.include? err
    end

    # If minFraud sends back an error or warning message, this will return the message, otherwise nil.
    # @return [String, nil] minFraud error field in response
    def error
      err
    end

    # Parses raw response body and turns its keys and values into attributes on self.
    # @param body [String] raw response body string
    def decode_body(body)
      # We bind the resultant hash to @body for #method_missing
      @body = transform_keys(Hash[body.split(';').map { |e| e.split('=') }])
    end

    # Snake cases and symbolizes keys in passed hash.
    # @param hash [Hash]
    def transform_keys(hash)
      hash = hash.to_a
      hash.map! do |e|
        key = e.first
        value = e.last
        if key.match(/\A[A-Z]+\z/)
          key = key.downcase
        else
          key = key.
          gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
          gsub(/([a-z])([A-Z])/, '\1_\2').
          downcase.
          to_sym
        end
        [key, value]
      end
      Hash[hash]
    end

    # Allows keys in hash contained in @body to be used as methods
    def method_missing(meth, *args, &block)
      # We're not calling super because we want nil if an attribute isn't found
      @body[meth]
    end

  end
end
