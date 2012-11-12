require 'spec_helper'

describe FaradayMiddleware::ConvertSdataToHeaders do

  def fixture_data(total_results, start_index, items_per_page)
    raw = fixture('sales_invoices.json').read
    raw.sub!(/"\$totalResults":(\d+)/, %Q("$totalResults":#{total_results}))
    raw.sub!(/"\$startIndex":(\d+)/,   %Q("$startIndex":#{start_index}))
    raw.sub!(/"\$itemsPerPage":(\d+)/, %Q("$itemsPerPage":#{items_per_page}))
  end

  def connection(include_mashify=true)
    Faraday.new(url: sage_url(nil)) do |conn|
      conn.request :json
      conn.use FaradayMiddleware::Mashify if include_mashify
      conn.use FaradayMiddleware::ConvertSdataToHeaders
      conn.use FaradayMiddleware::ParseJson
      conn.adapter  Faraday.default_adapter
    end
  end

  context "when on the first page"do
    it "does not add a prev link" do
      stub_get('sales_invoices').to_return(body: fixture_data(20, 0, 20))
      response = connection.get('sales_invoices')
      expect(response.headers).to be_empty
    end
    context "and there are more results than items_per_page" do
      it "adds a next link" do
        stub_get('sales_invoices').to_return(body: fixture_data(40, 0, 20))
        response = connection.get('sales_invoices')
        expect(response.headers['Link']).to_not be_nil
        expect(response.headers['Link']).to include(%Q{<#{sage_url('sales_invoices?%24startIndex=20')}>; rel="next"})
      end
    end
  end

  context "when on the last page" do
    before { stub_get('sales_invoices').to_return(body: fixture_data(40, 20, 20)) }
    it "does not add a next link" do
      response = connection.get('sales_invoices')
      expect(response.headers).to_not include('rel="next"')
    end
    it "adds a prev link" do
      response = connection.get('sales_invoices')
      expect(response.headers['Link']).to_not be_nil
      expect(response.headers['Link']).to include(%Q{<#{sage_url('sales_invoices?%24startIndex=0')}>; rel="prev"})
    end
    context "when requesting a value in the middle of the last page" do
      before { stub_get('sales_invoices').to_return(body: fixture_data(40, 30, 20)) }
      it "does not add a next link" do
        response = connection.get('sales_invoices')
        expect(response.headers).to_not include('rel="next"')
      end
      it "adds a prev link" do
        response = connection.get('sales_invoices')
        expect(response.headers['Link']).to_not be_nil
        expect(response.headers['Link']).to include(%Q{<#{sage_url('sales_invoices?%24startIndex=10')}>; rel="prev"})
      end
    end
  end

  context "when there are fewer results than items_per_page" do
    before { stub_get('sales_invoices').to_return(body: fixture_data(5, 0, 20)) }
    it "adds no links" do
      response = connection.get('sales_invoices')
      expect(response.headers['Link']).to be_nil
    end
  end

  context "when on a middle page" do
    before { stub_get('sales_invoices').to_return(body: fixture_data(20, 10, 5)) }
    it "adds a prev link" do
      response = connection.get('sales_invoices')
      expect(response.headers['Link']).to include(%Q{<#{sage_url('sales_invoices?%24startIndex=5')}>; rel="prev"})
    end
    it "adds a next link" do
      response = connection.get('sales_invoices')
      expect(response.headers['Link']).to include(%Q{<#{sage_url('sales_invoices?%24startIndex=15')}>; rel="next"})
    end
  end

  context "when there is already a Link header present" do
    before { stub_get('sales_invoices').to_return(body: fixture_data(20, 10, 5), headers: { 'Link' => '<mailto:timbl@w3.org>; rev="Made"; title="Tim Berners-Lee"' }) }
    it "does not destroy it" do
      response = connection.get('sales_invoices')
      expect(response.headers['Link']).to eq('<mailto:timbl@w3.org>; rev="Made"; title="Tim Berners-Lee", <https://app.sageone.com/api/v1/sales_invoices?%24startIndex=15>; rel="next", <https://app.sageone.com/api/v1/sales_invoices?%24startIndex=5>; rel="prev"')
    end
  end

  it "places the resources in the body of the response" do
    stub_get('sales_invoices').to_return(body: fixture_data(20, 10, 5))
    response = connection(false).get('sales_invoices')
    response.body.to_s.should eq(JSON.parse(fixture_data(20,10,5))['$resources'].to_s)
  end

  context "when there are existing query parameters" do
    before { stub_get('sales_invoices?search=salad&from_date=2012-11-11').to_return(body: fixture_data(20, 10, 5)) }
    it "it passes them through without modification" do
      response = connection.get('sales_invoices?from_date=2012-11-11&search=salad')
      expect(response.headers['Link']).to eq('<https://app.sageone.com/api/v1/sales_invoices?%24startIndex=15&from_date=2012-11-11&search=salad>; rel="next", <https://app.sageone.com/api/v1/sales_invoices?%24startIndex=5&from_date=2012-11-11&search=salad>; rel="prev"')
    end
  end

  context 'when there is no SData' do
    before { stub_get('sales_invoices/954380').to_return(body: fixture('sales_invoice.json')) }
    it "does not create link headers" do
      response = connection.get('sales_invoices/954380')
      expect(response.headers['Link']).to be_nil
    end
    it "leaves the resources in the body of the response" do
      response = connection(false).get('sales_invoices/954380')
      response.body.to_s.should eq(JSON.parse(fixture('sales_invoice.json').read).to_s)
    end
  end

  context 'within first page of results, but not from start_index of 0' do
    before { stub_get('sales_invoices').to_return(body: fixture_data(20, 3, 5)) }
    it "Adds a previous link to start_index=0" do
      response = connection.get('sales_invoices')
      expect(response.headers['Link']).to include(%Q{<#{sage_url('sales_invoices?%24startIndex=0')}>; rel="prev"})
    end
    it "Adds a next link to start_index=8" do
      response = connection.get('sales_invoices')
      expect(response.headers['Link']).to include(%Q{<#{sage_url('sales_invoices?%24startIndex=8')}>; rel="next"})
    end
  end
end