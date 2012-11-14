module SageOne
  class Client
    module SalesInvoices

      # List sales invoices
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :contact Milestone number.
      # @option options [Integer] :status (open) State: <tt>open</tt> or <tt>closed</tt>.
      # @option options [String] :search User login.
      # @option options [String] :from_date 'dd/mm/yyyy'
      # @option options [Date] :from_date - any object that responds to strftime
      # @option options [String] :to_date 'dd/mm/yyyy'
      # @option options [Date] :to_date - any object that responds to strftime
      # @option options [Integer] :start_index
      # @return [Array] A list of all sales_invoices
      # @example Get all sales invoices
      #   SageOne.sales_invoices
      def sales_invoices(options={})
        get("sales_invoices", options)
      end

      def create_sales_invoice(options)
        post('sales_invoices', sales_invoice: options)
      end

      def sales_invoice(id)
        get "sales_invoices/#{id}"
      end

      def update_sales_invoice(id, options)
        put("sales_invoices/#{id}", sales_invoice: options)
      end

      def delete_sales_invoice!(id)
        delete("sales_invoices/#{id}")
      end

    end
  end
end