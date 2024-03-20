module SageOne
  class Client
    module V3_1
      # module SageOne::Client::V3::Contacts
      module Businesses
        # List Businesses
        # @param options [Hash] A customizable set of options.
        # @return [Array<PaymentMethod>] A list of all Businesses. Each PaymentMethod is a Hashie.
        # @example Get all Businesses
        #   SageOne.businesses
        def businesses(options = {})
          get('businesses', options)
        end

        # Get a PaymentMethod record by ID
        # @param [Integer] id PaymentMethod ID
        # @return [Hashie::Mash] PaymentMethod record
        # @example Get a PaymentMethod:
        #   SageOne.business(12345)
        def business(id)
          get("businesses/#{id}")
        end
      end
    end
  end
end
