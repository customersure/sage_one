module SageOne
  class Client
    module V3_1
      # A contact payment is a payment that relates to a contact and
      # an artefact that requires payment, i.e. usually an invoice.

      # module SageOne::Client::V3::ContactPayments
      module ContactPayments
        # List ContactPayments
        # @param options [Hash] A customizable set of options.
        # @return [Array<ContactPayment>] A list of all ContactPayments. Each ContactPayment is a Hashie.
        # @example Get all ContactPayments
        #   SageOne.contact_payments
        def contact_payments(options = {})
          get('contact_payments', options)
        end

        # Create a ContactPayment.
        # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
        #                       i.e. { contact_payment: {options} }, just pass in the options hash.
        # @return [ContactPayment] A Hashie of the created ContactPayment.
        def create_contact_payment(options)
          post('contact_payments', contact_payment: options)
        end

        # Get a ContactPayment record by ID
        # @param [Integer] id ContactPayment ID
        # @return [Hashie::Mash] ContactPayment record
        # @example Get a ContactPayment:
        #   SageOne.contact_payment(12345)
        def contact_payment(id)
          get("contact_payments/#{id}")
        end

        # Update a ContactPayment
        # @param id [Integer] The id of the ContactPayment you want to update.
        # @param (see #create_contact_payment)
        # @return [ContactPayment] A Hashie of the updated ContactPayment.
        def update_contact_payment(id, options)
          put("contact_payments/#{id}", contact_payment: options)
        end

        # Delete a ContactPayment.
        # @param id [Integer] The id of the ContactPayment you want to delete.
        # @return [ContactPayment] A Hashie of the deleted ContactPayment
        # @example Delete an ContactPayment
        #    contact_payment = SageOne.delete_contact_payment!(12)
        def delete_contact_payment!(id)
          delete("contact_payments/#{id}")
        end
      end
    end
  end
end
