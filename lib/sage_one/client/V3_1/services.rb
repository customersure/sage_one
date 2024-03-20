module SageOne
  class Client
    module V3_1
      # module SageOne::Client::V3::Services
      module Services
        # List Services
        # @param options [Hash] A customizable set of options.
        # @return [Array<Service>] A list of all services. Each Service is a Hashie.
        # @example Get all services
        #   SageOne.services
        def services(options = {})
          get('services', options)
        end

        # Create a Service.
        # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
        #                       i.e. { service: {options} }, just pass in the options hash.
        # @return [Service] A Hashie of the created Service.
        def create_service(options)
          post('services', service: options)
        end

        # Get a service record by ID
        # @param [Integer] id Service ID
        # @return [Hashie::Mash] Service record
        # @example Get a service:
        #   SageOne.service(12345)
        def service(id)
          get("services/#{id}")
        end

        # Update a Service
        # @param id [Integer] The id of the Service you want to update.
        # @param (see #create_service)
        # @return [Service] A Hashie of the updated Service.
        def update_service(id, options)
          put("services/#{id}", service: options)
        end

        # Delete a Service.
        # @param id [Integer] The id of the service you want to delete.
        # @return [Service] A Hashie of the deleted service
        # @example Delete an service
        #    service = SageOne.delete_service!(12)
        def delete_service!(id)
          delete("services/#{id}")
        end
      end
    end
  end
end
