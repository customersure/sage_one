module SageOne
  class Client
    module V3_1
      # module SageOne::Client::V3::TaxRates
      module TaxRates
        # Currently Create, Update and Delete APIs are only available for US. 

        # List TaxRates
        # @param options [Hash] A customizable set of options.
        # @return [Array<TaxRate>] A list of all TaxRates. Each TaxRate is a Hashie.
        # @example Get all TaxRates
        #   SageOne.tax_rates
        def tax_rates(options = {})
          get('tax_rates', options)
        end

        # Create a TaxRate.
        # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
        #                       i.e. { tax_rate: {options} }, just pass in the options hash.
        # @return [TaxRate] A Hashie of the created TaxRate.
        def create_tax_rate(options)
          post('tax_rates', tax_rate: options)
        end

        # Get a TaxRate record by ID
        # @param [Integer] id TaxRate ID
        # @return [Hashie::Mash] TaxRate record
        # @example Get a TaxRate:
        #   SageOne.tax_rate(12345)
        def tax_rate(id)
          get("tax_rates/#{id}")
        end

        # Update a TaxRate
        # @param id [Integer] The id of the TaxRate you want to update.
        # @param (see #create_tax_rate)
        # @return [TaxRate] A Hashie of the updated TaxRate.
        def update_tax_rate(id, options)
          put("tax_rates/#{id}", tax_rate: options)
        end

        # Delete a TaxRate.
        # @param id [Integer] The id of the TaxRate you want to delete.
        # @return [TaxRate] A Hashie of the deleted TaxRate
        # @example Delete an TaxRate
        #    tax_rate = SageOne.delete_tax_rate!(12)
        def delete_tax_rate!(id)
          delete("tax_rates/#{id}")
        end
      end
    end
  end
end
