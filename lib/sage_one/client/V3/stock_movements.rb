module SageOne
  class Client
    module V3
      # module SageOne::Client::V3::StockMovements
      module StockMovements
        # List StockMovements
        # @param options [Hash] A customizable set of options.
        # @return [Array<StockMovement>] A list of all StockMovements. Each StockMovement is a Hashie.
        # @example Get all StockMovements
        #   SageOne.stock_movements
        def stock_movements(options = {})
          get('stock_movements', options)
        end

        # Create a StockMovement.
        # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
        #                       i.e. { stock_movement: {options} }, just pass in the options hash.
        # @return [StockMovement] A Hashie of the created StockMovement.
        def create_stock_movement(options)
          post('stock_movements', stock_movement: options)
        end

        # Get a StockMovement record by ID
        # @param [Integer] id StockMovement ID
        # @return [Hashie::Mash] StockMovement record
        # @example Get a StockMovement:
        #   SageOne.stock_movement(12345)
        def stock_movement(id)
          get("stock_movements/#{id}")
        end

        # Update a StockMovement
        # @param id [Integer] The id of the StockMovement you want to update.
        # @param (see #create_stock_movement)
        # @return [StockMovement] A Hashie of the updated StockMovement.
        def update_stock_movement(id, options)
          put("stock_movements/#{id}", stock_movement: options)
        end

        # Delete a StockMovement.
        # @param id [Integer] The id of the StockMovement you want to delete.
        # @return [StockMovement] A Hashie of the deleted StockMovement
        # @example Delete an StockMovement
        #    stock_movement = SageOne.delete_stock_movement!(12)
        def delete_stock_movement!(id)
          delete("stock_movements/#{id}")
        end
      end
    end
  end
end
