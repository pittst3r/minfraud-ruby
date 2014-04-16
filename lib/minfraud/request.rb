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
    def post
      Response.new(send_post_request)
    end

    # (see #post)
    # @param trans [Transaction] transaction to post to MaxMind
    def self.post(trans)
      new(trans).post
    end

    private

    # Transforms Transaction object into a hash for Net::HTTP::Post
    # @return [Hash] keys are strings with minFraud field names
    def encoded_body
      Hash[@transaction.attributes.map { |k, v| [FIELD_MAP[k], v] }]
    end

    # Creates a Net::HTTP::Post object for the request
    # @return [Net::HTTP::Post]
    def post_object
      # Ruby 1.9.3 requires a string rather than a URI object
      Net::HTTP::Post.new(Minfraud.uri.to_s, encoded_body)
    end

    # @return [Net::HTTPResponse]
    def send_post_request
      Net::HTTP.start(Minfraud.uri.hostname, Minfraud.uri.port, use_ssl: true) do |http|
        http.request(post_object)
      end
    end

  end
end
