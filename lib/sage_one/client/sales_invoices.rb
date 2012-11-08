module SageOne
  class Client
    module SalesInvoices

      # TODO:
      # Make date option work with objects

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
    end
  end
end