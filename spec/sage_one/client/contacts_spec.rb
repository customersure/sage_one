require 'spec_helper'

describe SageOne::Client::Contacts do

  let(:client) { SageOne.new }

  describe '.contact' do
    context 'when the contact exists' do
      it 'returns a Hashie::Mash of the contact' do
        stub_get('contacts/1').to_return(body: fixture('contact.json'))
        contact = client.contact(1)
        expect(contact).to be_a(Hashie::Mash)
        expect(contact.name).to eq('Luke Brown')
        expect(contact.email).to eq('luke.brown@example.com')
      end
    end
  end

end
