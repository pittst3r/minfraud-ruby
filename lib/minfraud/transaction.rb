require 'digest/md5'

module Minfraud

  # This is the container for the data you're sending to MaxMind.
  # A transaction holds data like name, address, IP, order amount, etc.
  class Transaction

    # Required attribute
    attr_accessor :ip, :city, :state, :postal, :country

    # Shipping address attribute (optional)
    attr_accessor :ship_addr, :ship_city, :ship_state, :ship_postal, :ship_country

    # User attribute (optional)
    attr_accessor :email, :phone

    # Credit card attribute (optional)
    attr_accessor :bin

    # Transaction linking attribute (optional)
    attr_accessor :session_id, :user_agent, :accept_language

    # Transaction attribute (optional)
    attr_accessor :txn_id, :amount, :currency, :txn_type

    # Credit card result attribute (optional)
    attr_accessor :avs_result, :cvv_result

    # Miscellaneous attribute (optional)
    attr_accessor :requested_type, :forwarded_ip

    def initialize
      yield self
      unless has_required_attributes?
        raise TransactionError, 'You did not set all the required transaction attributes.'
      end
      validate_attributes
    end

    # Retrieves the risk score from MaxMind.
    # A higher score indicates a higher risk of fraud.
    # For example, a score of 20 indicates a 20% chance that a transaction is fraudulent.
    # @return [Float] 0.01 - 100.0
    def risk_score
      results.risk_score
    end

    # Hash of attributes that have been set
    # @return [Hash] present attributes
    def attributes
      {
        ip: ip,
        city: city,
        state: state,
        postal: postal,
        country: country,
        license_key: Minfraud.license_key,
        ship_addr: ship_addr,
        ship_city: ship_city,
        ship_state: ship_state,
        ship_postal: ship_postal,
        ship_country: ship_country,
        email_domain: email.to_s.split('@').last,
        email_md5: Digest::MD5.hexdigest(email.to_s),
        phone: phone,
        bin: bin,
        session_id: session_id,
        user_agent: user_agent,
        accept_language: accept_language,
        txn_id: txn_id,
        amount: amount,
        currency: currency,
        txn_type: txn_type,
        avs_result: avs_result,
        cvv_result: cvv_result,
        requested_type: (requested_type or Minfraud.requested_type),
        forwarded_ip: forwarded_ip
      }
    end

    private

    # Ensures the required attributes are present
    # @return [Boolean]
    def has_required_attributes?
      ip and city and state and postal and country
    end

    # Validates the types of the attributes
    # @return [nil, TransactionError]
    def validate_attributes
      [:ip, :city, :state, :postal, :country].each { |s| validate_string(s) }
    end

    # Given the symbol of an attribute that should be a string,
    # it checks the attribute's type and throws an error if it's not a string.
    # @param attr_name [Symbol] name of the attribute to validate
    # @return [nil, TransactionError]
    def validate_string(attr_name)
      attribute = self.send(attr_name)
      unless attribute.instance_of?(String)
        raise TransactionError, "Transaction.#{attr_name} must me a string"
      end
    end

    # Sends transaction to MaxMind in order to get risk data on it.
    # Caches response object in @response.
    # @return [Response]
    def results
      @response ||= Request.get(self)
    end

  end
end
