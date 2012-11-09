require 'spec_helper'

describe FaradayMiddleware::OAuth2 do

  let(:client) { SageOne.new }

  before { stub_get('sales_invoices') }

  context 'when the access_token is nil' do
    it 'does not add an Authorization header' do
      client.send(:connection).get do |request|
        request.url 'sales_invoices'
        expect(request.headers.keys).not_to include("Authorization")
      end
      a_get("sales_invoices").should have_been_made.once
      a_get("sales_invoices").with(:headers => { "Authorization" => "Bearer #{nil}"}).should_not have_been_made
    end
  end

  context 'when the access_token is set' do
    let(:access_token) { 'wHeHaMwscCIEOLGQ9uIi' }
    before { client.access_token = access_token }

    it 'adds an Authorization header with the Bearer token' do
      client.send(:connection).get('sales_invoices')
      a_get("sales_invoices").with(:headers => { 'Authorization' => "Bearer #{access_token}" }).should have_been_made.once
    end
  end

  context 'when the Authorization header has already been set' do
    let(:access_token) { 'wHeHaMwscCIEOLGQ9uIi' }
    let(:pre_set_access_token) { 'SuperBearer my_pre_set_token' }
    before { client.access_token = access_token }

    it 'leaves the set Authorization header alone' do
      client.send(:connection).get do |request|
        request.url 'sales_invoices'
        request.headers['Authorization'] = pre_set_access_token
      end
      a_get("sales_invoices").with(:headers => { 'Authorization' => pre_set_access_token }).should have_been_made.once
    end
  end

end
