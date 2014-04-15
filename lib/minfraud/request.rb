require 'net/http'

module Minfraud

  class Request

    # @param trans [Transaction] transaction to be sent to MaxMind
    def initialize(trans)
      @transaction = trans
    end

    # Sends transaction to MaxMind and gives raw response to Response for handling
    # @return [Response] wrapper for minFraud response
    def post

    end

    # (see #post)
    # @param trans [Transaction] transaction to post to MaxMind
    def self.post(trans)
      new(trans).post
    end

    private

    # Transforms Transaction object into the encoding MaxMind is expecting
    # @return [String]
    def encode_body

    end

  end
end
