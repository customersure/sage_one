require 'spec_helper'

describe SageOne::Client::SalesInvoices do

  let(:client) { SageOne.new }

  describe 'sales_invoices' do
    it 'returns an array of Hashie::Mashes, representing the available invoices' do
      stub_get('sales_invoices').to_return(body: fixture('sales_invoices.json'))
      inv = client.sales_invoices.first
      expect(inv.outstanding_amount).to eq '17.0'
      expect(inv.outstanding_amount).to eq '17.0'
      expect(inv.notes).to eq 'future date. did email it.'
    end
  end

  describe 'create_sales_invoice' do
    it 'posts to the correct endpoint and returns the new invoice' do
      stub_post('sales_invoices').to_return(body: fixture('sales_invoice.json'))
      invoice = client.create_sales_invoice(foo: 'bar')
      a_post('sales_invoices').with(body: { sales_invoice: { foo: 'bar' } }).should have_been_made.once
      expect(invoice.invoice_number).to eq 'SI-4'
    end
  end

  describe 'sales_invoice' do
    it 'gets the requested sales invoice' do
      stub_get('sales_invoices/333').to_return(body: fixture('sales_invoice.json'))
      invoice = client.sales_invoice(333)
      a_get('sales_invoices/333').should have_been_made.once
      expect(invoice.invoice_number).to eq 'SI-4'
    end
  end

  describe 'update_sales_invoice' do
    it "makes a put and returns the new invoice" do
      stub_put('sales_invoices/333').to_return(body: fixture('sales_invoice.json'))
      invoice = client.update_sales_invoice(333, foo: 'bar')
      a_put('sales_invoices/333').with(body: { sales_invoice: { foo: 'bar' } }).should have_been_made.once
      expect(invoice.invoice_number).to eq 'SI-4'
    end
  end

  describe 'delete_sales_invoice!' do
    it "makes a delete and returns the deleted invoice" do
      stub_delete('sales_invoices/444').to_return(body: fixture('sales_invoice.json'))
      invoice = client.delete_sales_invoice!(444)
      a_delete('sales_invoices/444').should have_been_made.once
      expect(invoice.invoice_number).to eq 'SI-4'
    end
  end

end