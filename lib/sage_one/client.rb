require 'sage_one/connection'
require 'sage_one/request'

require 'sage_one/oauth'

require 'sage_one/client/sales_invoices'

module SageOne
  class Client
    attr_accessor(*Configuration::VALID_OPTIONS_KEYS)

    def initialize(options={})
      options = SageOne.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    include SageOne::Connection
    include SageOne::Request

    include SageOne::OAuth

    include SageOne::Client::SalesInvoices
  end
end
