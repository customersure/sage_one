module SageOne
  class Client
    module V3_1
      # module SageOne::Client::V3::Addresses
      module Addresses
        # List Addresses
        # @param options [Hash] A customizable set of options.
        # @return [Array<Addresses>] A list of all addresses. Each Addresses is a Hashie.
        # @example Get all addresses
        #   SageOne.addresses
        def addresses(options = {})
          get('addresses', options)
        end

        # Create a Address.
        # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
        #                       i.e. { address: {options} }, just pass in the options hash.
        # @return [Address] A Hashie of the created Address.
        def create_address(options)
          post('addresses', address: options)
        end

        # Get a Address record by ID
        # @param [Integer] id Address ID
        # @return [Hashie::Mash] Address record
        # @example Get a Address:
        #   SageOne.address(12345)
        def address(id)
          get("addresses/#{id}")
        end

        # Update a Address
        # @param id [Integer] The id of the Address you want to update.
        # @param (see #create_address)
        # @return [Address] A Hashie of the updated Address.
        def update_address(id, options)
          put("addresses/#{id}", address: options)
        end
      end
    end
  end
end
