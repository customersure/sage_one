require 'spec_helper'

describe FaradayMiddleware::RaiseSageOneException do
  let(:client) { SageOne::Client.new }

  {
    400 => SageOne::BadRequest,
    401 => SageOne::Unauthorized,
    403 => SageOne::Forbidden,
    404 => SageOne::NotFound,
    409 => SageOne::Conflict,
    422 => SageOne::UnprocessableEntity,
  }.each do |status, exception|
    context "when HTTP status is #{status}" do

      before { stub_get('sales_invoices').to_return(:status => status) }

      it "raises #{exception.name} error" do
        expect { client.sales_invoices }.to raise_error(exception)
      end
    end
  end

  context "when the response body contains an error: key (i.e. from OAuth)" do
    before { stub_get('sales_invoices').to_return(:status => 400, body: { error: "Unauthorised Access" }) }
    it "raises an error with the error message" do
      expect { client.sales_invoices }.to raise_error(SageOne::BadRequest, /Unauthorised Access/)
    end
  end

  context "when the response body contains validation errors" do
    before { stub_post('sales_invoices').to_return(:status => 422, body: fixture('invalid_sales_invoice.json')) }
    it "includes the validation errors" do
      expect { client.post('sales_invoices', {}) }.to raise_error(SageOne::UnprocessableEntity, /due_date: invalid date/)
    end
  end

end
