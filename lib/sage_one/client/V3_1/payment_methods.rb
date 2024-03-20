module SageOne
  class Client
    module V3_1
      # module SageOne::Client::V3::Contacts
      module PaymentMethods
        # List PaymentMethods
        # @param options [Hash] A customizable set of options.
        # @return [Array<PaymentMethod>] A list of all PaymentMethods. Each PaymentMethod is a Hashie.
        # @example Get all PaymentMethods
        #   SageOne.payment_methods
        def payment_methods(options = {})
          get('payment_methods', options)
        end

        # Get a PaymentMethod record by ID
        # @param [Integer] id PaymentMethod ID
        # @return [Hashie::Mash] PaymentMethod record
        # @example Get a PaymentMethod:
        #   SageOne.payment_method(12345)
        def payment_method(id)
          get("payment_methods/#{id}")
        end
      end
    end
  end
end
