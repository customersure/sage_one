require 'spec_helper'

describe SageOne do

  describe '.new' do
    it { SageOne.new.should be_a(SageOne::Client) }
  end

  describe '.respond_to?' do
    it 'returns true when the method exists' do
      expect(SageOne.respond_to?(:new, true)).to be_true
    end
    it 'returns true when a client responds to the method' do
      expect(SageOne.respond_to?(:sales_invoices)).to be_true
    end
    it 'returns false when the method does not exist' do
      expect(SageOne.respond_to?(:noway, true)).to be_false
    end
  end

  describe '.method_missing' do
    context "when the client does not respond to the method either" do
      it 'raises a NoMethodError' do
        expect(lambda{ SageOne.noway }).to raise_error(NoMethodError)
      end
    end
    context "when the client does respond to the method" do
      it 'delegates the call to the client, passing any args and block' do
        block = Proc.new { puts "hi" }
        mock_client = mock('SageOne::Client', :my_method => 'called')
        SageOne.should_receive(:new).twice.and_return(mock_client)
        mock_client.should_receive(:my_method).with('abc', block)
        SageOne.my_method('abc', block)
      end
    end
  end

end
