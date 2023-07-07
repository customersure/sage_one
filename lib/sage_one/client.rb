require 'sage_one/connection'
require 'sage_one/request'

require 'sage_one/oauth'

API_ENDPOINTS = %w[businesses contacts contact_persons addresses sales_invoices tax_rates stock_movements stock_items services payment_methods contact_payments bank_accounts ledger_accounts sales_invoices]

API_ENDPOINTS.each { |file_name| require "sage_one/client/V3_1/#{file_name}.rb" }

module SageOne
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    # Creates an instance of Client configured with
    # the current SageOne::Configuration options.
    # Pass in a hash of any valid options to override
    # them for this instance.
    #
    # @see SageOne::Configuration::VALID_OPTIONS_KEYS
    #   SageOne::Configuration::VALID_OPTIONS_KEYS
    def initialize(options = {})
      options = SageOne.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include SageOne::Connection
    include SageOne::Request
    include SageOne::OAuth

    API_ENDPOINTS.each do |file|
      file_name_without_extension = File.basename(file, '.rb')
      file_name = file_name_without_extension.split('_').map(&:capitalize).join
      include const_get("SageOne::Client::V3_1::#{file_name}")
    end
  end
end
