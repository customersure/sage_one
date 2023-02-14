module SageOne
  class Client
    module V3
      # module SageOne::Client::V3::StockItems
      module StockItems
        # List StockItems
        # @param options [Hash] A customizable set of options.
        # @return [Array<StockItem>] A list of all StockItems. Each StockItem is a Hashie.
        # @example Get all StockItems
        #   SageOne.stock_items
        def stock_items(options = {})
          get('stock_items', options)
        end

        # Create a StockItem.
        # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
        #                       i.e. { stock_item: {options} }, just pass in the options hash.
        # @return [StockItem] A Hashie of the created StockItem.
        def create_stock_item(options)
          post('stock_items', stock_item: options)
        end

        # Get a StockItem record by ID
        # @param [Integer] id StockItem ID
        # @return [Hashie::Mash] StockItem record
        # @example Get a StockItem:
        #   SageOne.stock_item(12345)
        def stock_item(id)
          get("stock_items/#{id}")
        end

        # Update a StockItem
        # @param id [Integer] The id of the StockItem you want to update.
        # @param (see #create_stock_item)
        # @return [StockItem] A Hashie of the updated StockItem.
        def update_stock_item(id, options)
          put("stock_items/#{id}", stock_item: options)
        end

        # Delete a StockItem.
        # @param id [Integer] The id of the StockItem you want to delete.
        # @return [StockItem] A Hashie of the deleted StockItem
        # @example Delete an StockItem
        #    stock_item = SageOne.delete_stock_item!(12)
        def delete_stock_item!(id)
          delete("stock_items/#{id}")
        end
      end
    end
  end
end
