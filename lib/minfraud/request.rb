require 'net/http'
require 'openssl'

module Minfraud

  class Request

    FIELD_MAP = {
      ip: 'i',
      city: 'city',
      state: 'region',
      postal: 'postal',
      country: 'country',
      license_key: 'license_key',
      ship_addr: 'shipAddr',
      ship_city: 'shipCity',
      ship_state: 'shipRegion',
      ship_postal: 'shipPostal',
      ship_country: 'shipCountry',
      email_domain: 'domain',
      email_md5: 'emailMD5',
      phone: 'custPhone',
      bin: 'bin',
      session_id: 'sessionID',
      user_agent: 'user_agent',
      accept_language: 'accept_language',
      txn_id: 'txnID',
      amount: 'order_amount',
      currency: 'order_currency',
      txn_type: 'txn_type',
      avs_result: 'avs_result',
      cvv_result: 'cvv_result',
      requested_type: 'requested_type',
      forwarded_ip: 'forwardedIP'
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
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request)
    end

  end
end
