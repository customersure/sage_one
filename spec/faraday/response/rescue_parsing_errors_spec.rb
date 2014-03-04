require 'spec_helper'

describe FaradayMiddleware::RescueParsingErrors do
  let(:client) { SageOne::Client.new }
  before { stub_get('sales_invoices').to_return(status: 403, body: "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\"> <html><head> <title>403 Forbidden</title> </head><body> <h1>Forbidden</h1> <p>You don't have permission to access /api/v1/sales_invoices on this server.</p> </body></html>") }

  it "Intercepts the faraday error and send a SageOne error we can handle." do
    expect { client.sales_invoices }.to raise_error("SageOne sent HTML instead of JSON. Status was 403.")
  end
end


