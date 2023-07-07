module SageOne
  class Client
    module V3_1
      # module SageOne::Client::V3::ContactPersons
      module ContactPersons
        # List ContactPersons
        # @param options [Hash] A customizable set of options.
        # @return [Array<ContactPerson>] A list of all ContactPersons. Each ContactPerson is a Hashie.
        # @example Get all ContactPersons
        #   SageOne.contact_persons
        def contact_persons(options = {})
          get('contact_persons', options)
        end

        # Create a ContactPerson.
        # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
        #                       i.e. { contact_person: {options} }, just pass in the options hash.
        # @return [ContactPerson] A Hashie of the created ContactPerson.
        def create_contact_person(options)
          post('contact_persons', contact_person: options)
        end

        # Get a ContactPerson record by ID
        # @param [Integer] id ContactPerson ID
        # @return [Hashie::Mash] ContactPerson record
        # @example Get a ContactPerson:
        #   SageOne.contact_person(12345)
        def contact_person(id)
          get("contact_persons/#{id}")
        end

        # Update a ContactPerson
        # @param id [Integer] The id of the ContactPerson you want to update.
        # @param (see #create_contact_person)
        # @return [ContactPerson] A Hashie of the updated ContactPerson.
        def update_contact_person(id, options)
          put("contact_persons/#{id}", contact_person: options)
        end
      end
    end
  end
end
