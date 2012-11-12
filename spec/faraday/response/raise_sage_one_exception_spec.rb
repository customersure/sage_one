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

  [
    {:error => "Unauthorised activity"}
  ].each do |body|
    context "when the response body contains an error message" do

      before { stub_get('sales_invoices').to_return(:status => 400, body: body) }

      it "raises an error with the error message" do
        expect { client.sales_invoices }.to raise_error(SageOne::BadRequest, /#{body.values.first}/)
      end
    end
  end

end
