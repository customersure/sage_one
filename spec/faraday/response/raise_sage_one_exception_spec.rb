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
      expect { client.sales_invoices }.to raise_error(SageOne::BadRequest, '{"method":"get","url":"https://app.sageone.com/api/v1/sales_invoices","status":400,"body":{"error":"Unauthorised Access"}}')
    end
  end

  context "when the response body contains validation errors" do
    before { stub_post('sales_invoices').to_return(:status => 422, body: fixture('invalid_sales_invoice.json')) }
    it "includes the validation errors" do
      expect { client.post('sales_invoices', {}) }.to raise_error(SageOne::UnprocessableEntity, %q{{"method":"post","url":"https://app.sageone.com/api/v1/sales_invoices","status":422,"body":{"$diagnoses":[{"$severity":"error","$dataCode":"ValidationError","$message":"blank","$source":"due_date"},{"$severity":"error","$dataCode":"ValidationError","$message":"invalid date","$source":"due_date"},{"$severity":"error","$dataCode":"ValidationError","$message":"blank","$source":"carriage_tax_code_id"},{"$severity":"error","$dataCode":"ValidationError","$message":"The type of sale associated with a product/service no longer exists. Check product/service and try again.","$source":"line_items"}]}}})
    end
  end

  context "when the response body is nil" do
    before { stub_post('sales_invoices').to_return(:status => 422, body: nil) }
    it "just converts this to a blank string" do
      expect { client.post('sales_invoices', {}) }.to raise_error(SageOne::UnprocessableEntity, %q{{"method":"post","url":"https://app.sageone.com/api/v1/sales_invoices","status":422,"body":""}})
    end
  end

end
