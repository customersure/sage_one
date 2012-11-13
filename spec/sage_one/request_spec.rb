require 'spec_helper'

describe SageOne::Request do

  let(:client) { SageOne.new }

  describe 'helper methods' do
    before { client.stub(:request) }

    [:get, :delete, :post, :put].each do |meth|
      it "#{meth} exists and delegates to request" do
        client.should_receive(:request).with(meth, 'foo', {})
        client.send(meth, 'foo')
      end
    end
  end

  describe 'request' do
    context 'get/delete' do
      it "makes a get request" do
        stub_get('sales_invoices')
        client.get('sales_invoices')
        a_get('sales_invoices').should have_been_made.once
      end

      context 'with options' do
        it 'passes the options to the get request' do
          stub_get('sales_invoices?start_date=2011-12-13')
          client.get('sales_invoices', { start_date: '2011-12-13' })
          a_get('sales_invoices?start_date=2011-12-13').should have_been_made.once
        end
        it 'special-cases start_index' do
          stub_delete('sales_invoices?start_date=2011-12-13&%24startIndex=10')
          client.delete('sales_invoices', { start_date: '2011-12-13', start_index: 10 })
          a_delete('sales_invoices?start_date=2011-12-13&%24startIndex=10').should have_been_made.once
        end
      end
    end
    context 'put/post' do
      it "sets the request path" do
        stub_post('sales_invoices')
        client.post('sales_invoices')
        a_post('sales_invoices').should have_been_made.once
      end
      it "stores the options in the body" do
        stub_put('sales_invoices')
        client.put('sales_invoices', { "void_reason" => nil, "outstanding_amount" => "17.0", "total_net_amount" => "14.17"})
        a_put('sales_invoices').with(body: '{"void_reason":null,"outstanding_amount":"17.0","total_net_amount":"14.17"}').should have_been_made.once
      end
      describe 'auto-conversion of Date-y objects' do
        it "converts any options which are passed which resemble a date into a correctly-formatted date" do
          stub_put('sales_invoices/222')
          client.put('sales_invoices/222', { start_date: Time.new(2012, 10, 20)})
          a_put('sales_invoices/222').with(body: '{"start_date":"20/10/2012"}').should have_been_made.once
        end
      end
    end

    it 'Sets a request host if one is specified' do
      client.request_host = "CustomerHost"
      stub_get('sales_invoices')
      client.get('sales_invoices')
      a_get('sales_invoices').with(headers: { "Host" => 'CustomerHost' }).should have_been_made.once
    end

    describe "response body" do
      context 'raw requested' do
        it "returns a faraday response" do
          stub_get('sales_invoices')
          client.raw_response = true
          expect(client.get('sales_invoices', {})).to be_a(Faraday::Response)
        end
      end
      context 'not raw' do
        it "returns an array of Hashie::Mash-es" do
          stub_get('sales_invoices').to_return(body: fixture('sales_invoices.json'))
          expect(client.get('sales_invoices')).to be_a(Array)
          expect(client.get('sales_invoices').first).to be_a(Hashie::Mash)
          expect(client.get('sales_invoices').first.outstanding_amount).to eq("17.0")
          expect(client.get('sales_invoices').last).to be_a(Hashie::Mash)
        end
      end
    end

    context 'with auto_traversal turned on' do
      before { client.auto_traversal = true }
      it "recursively calls itself to build a complete result set" do

        stub_get("sales_invoices").to_return(:status => 200, :body => sdata_fixture('sales_invoices.json', 30, 0, 10))
        stub_get("sales_invoices?$startIndex=10").to_return(:status => 200, :body => sdata_fixture('sales_invoices.json', 30, 10, 10))
        stub_get("sales_invoices?$startIndex=20").to_return(:status => 200, :body => sdata_fixture('sales_invoices.json', 30, 20, 10))

        result = client.get("sales_invoices")

        a_get('sales_invoices').should have_been_made.once
        a_get('sales_invoices?$startIndex=10').should have_been_made.once
        a_get('sales_invoices?$startIndex=20').should have_been_made.once

        # The response should be three copies of the fixture file concatenated, so result[0] == result[2], etc
        expect(result.size).to eq(6)
        expect(result).to be_an(Array)
        expect(result[0]).to be_a(Hashie::Mash)
        expect(result[5]).to be_a(Hashie::Mash)
        expect(result[0]).to eq(result[2])
      end
    end
  end
end
