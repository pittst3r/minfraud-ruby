module Minfraud

  # This is the container for the data you're sending to MaxMind.
  # A transaction holds data like name, address, IP, order amount, etc.
  class Transaction

    # Required attributes when instantiating
    attr_accessor :ip, :city, :state, :postal, :country

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
      @response ||= Request.post(self)
    end

  end
end
