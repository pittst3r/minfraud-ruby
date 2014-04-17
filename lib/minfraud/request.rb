require 'net/http'

module Minfraud

  class Request

    FIELD_MAP = {
      ip: 'i',
      city: 'city',
      state: 'region',
      postal: 'postal',
      country: 'country',
      license_key: 'license_key'
    }

    # @param trans [Transaction] transaction to be sent to MaxMind
    def initialize(trans)
      @transaction = trans
    end

    # Sends transaction to MaxMind and gives raw response to Response for handling
    # @return [Response] wrapper for minFraud response
    def get
      Response.new(send_get_request)
    end

    # (see #get)
    # @param trans [Transaction] transaction to get to MaxMind
    def self.get(trans)
      new(trans).get
    end

    private

    # Transforms Transaction object into a hash for Net::HTTP::Get
    # @return [Hash] keys are strings with minFraud field names
    def encoded_query
      Hash[@transaction.attributes.map { |k, v| [FIELD_MAP[k], v] }]
    end

    # @return [Net::HTTPResponse]
    def send_get_request
      uri = Minfraud.uri
      uri.query = URI.encode_www_form(encoded_query)
      Net::HTTP.get_response(uri)
    end

  end
end
