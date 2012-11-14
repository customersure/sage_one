module SageOne
  class Client
    module SalesInvoices

      # List sales invoices
      # @param options [Hash] A customizable set of options.
      # @option options [Integer] :contact Use this to filter by contact id
      # @option options [Integer] :status Invoice payment status.
      # @option options [String] :search Filter by contact_name or reference (not case sensitive)
      # @option options [String, #strftime] :from_date Either a string formatted as 'dd/mm/yyyy' or an object which responds to strftime
      # @option options [String, #strftime] :to_date Either a string formatted as 'dd/mm/yyyy' or an object which responds to strftime
      # @option options [Integer] :start_index The start index in pagination to begin from.
      # @return [Array<Invoice>] A list of all sales_invoices. Each invoice is a Hashie.
      # @example Get all sales invoices
      #   SageOne.sales_invoices
      def sales_invoices(options={})
        get("sales_invoices", options)
      end

      # Create a sales invoice
      # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
      #                       i.e. { sales_invoice: {options} }, just pass in the options hash
      # @option options [String, #strftime] :date The invoice date either as a dd/mm/yyyy-formatted string or any object that responds to strftime
      # @option options [Integer] :contact_id The ID of the contact associated with the sales invoice. This must be a customer (contact_type 1).
      # @option options [String] :contact_name The name of the contact associated with the invoice. This should be the contact[name_and_company_name] from the ID of the specified contact.
      # @option options [String] :main_address  The address where the invoice is to be sent.
      # @option options [Integer] :carriage_tax_code_id The ID of the tax_rate if sales_invoice[carriage] is supplied.
      # @option options [Array<Hash>] :line_items_attributes An array of line items. Each Hash requires:
      #                               *  <b>:unit_price</b>        (<tt>Float</tt>) The unit cost of the line item.
      #                               *  <b>:quantity</b>          (<tt>Float</tt>) The number of units on the specified line item.
      #                               *  <b>:description</b>       (<tt>String</tt>) The description of the specified line item, maximum 60 characters.
      #                               *  <b>:tax_code_id</b>       (<tt>Integer</tt>) The ID of the tax_rate for the item line.
      #                               *  <b>:ledger_account_id</b> (<tt>Integer</tt>) The ID of the income_type.
      # @return [Invoice] A Hashie of the created invoice
      # @example Create a sales invoice:
      #     SageOne.create_sales_invoice({
      #       date: Time.now
      #       contact_id: 654
      #       contact_name: "Dave Regis"
      #       main_address: "Regis Enterprises, PO Box 123"
      #       carriage_tax_code_id: 5
      #       line_items_attributes: { unit_price: 12.34, quantity: 1.0, description: "Salmon steak", tax_code_id: 1, ledger_account_id: 987 }
      #     })
      def create_sales_invoice(options)
        post('sales_invoices', sales_invoice: options)
      end

      # Retrieve a sales invoice
      # @param id [Integer] The id of the invoice you want to retrieve.
      # @return [Invoice] A Hashie of the requested invoice
      # @example Load an invoice
      #     invoice = SageOne.sales_invoice(8754)
      def sales_invoice(id)
        get "sales_invoices/#{id}"
      end

      # Update a sales invoice
      # @param id [Integer] The id of the invoice you want to update.
      # @param (see #create_sales_invoice)
      # @option (see #create_sales_invoice)
      # @return [Invoice] A Hashie of the updated invoice
      def update_sales_invoice(id, options)
        put("sales_invoices/#{id}", sales_invoice: options)
      end

      # Delete a sales invoice
      # @param id [Integer] The id of the invoice you want to delete.
      # @return [Invoice] A Hashie of the deleted invoice
      # @example Delete an invoice
      #    invoice = SageOne.delete_sales_invoice!(12)
      def delete_sales_invoice!(id)
        delete("sales_invoices/#{id}")
      end
    end
  end
end

