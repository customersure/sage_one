module SageOne
  class Client
    module V3_1
      # module SageOne::Client::V3::Contacts
      module Contacts
        # List Contacts
        # @param options [Hash] A customizable set of options.
        # @return [Array<Contact>] A list of all contacts. Each Contact is a Hashie.
        # @example Get all contacts
        #   SageOne.contacts
        def contacts(options = {})
          get('contacts', options)
        end

        # Create a Contact.
        # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
        #                       i.e. { contact: {options} }, just pass in the options hash.
        # @return [Contact] A Hashie of the created Contact.
        def create_contact(options)
          post('contacts', contact: options)
        end

        # Get a contact record by ID
        # @param [Integer] id Contact ID
        # @return [Hashie::Mash] Contact record
        # @example Get a contact:
        #   SageOne.contact(12345)
        def contact(id)
          get("contacts/#{id}")
        end

        # Update a Contact
        # @param id [Integer] The id of the Contact you want to update.
        # @param (see #create_contact)
        # @return [Contact] A Hashie of the updated Contact.
        def update_contact(id, options)
          put("contacts/#{id}", contact: options)
        end

        # Delete a Contact.
        # @param id [Integer] The id of the contact you want to delete.
        # @return [contact] A Hashie of the deleted contact
        # @example Delete an contact
        #    contact = SageOne.delete_contact!(12)
        def delete_contact!(id)
          delete("contacts/#{id}")
        end
      end
    end
  end
end