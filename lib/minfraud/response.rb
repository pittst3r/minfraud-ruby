module Minfraud

  class Response

    # @param raw [Net::HTTPResponse]
    def initialize(raw)
      decode_body(raw.body)
    end

    # True if minFraud returns an error, false if not.
    # @return [Boolean]
    def errored?
      !@error.nil?
    end

    # If minFraud sends back an error message, this will return the message, otherwise nil.
    # @return [String, nil] minFraud error field in response
    def error
      @error
    end

    private

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
      @body[meth] ? @body[meth] : super
    end

  end
end
