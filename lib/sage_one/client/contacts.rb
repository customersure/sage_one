module SageOne
  class Client
    module Contacts
      # Get a contact record by ID
      # @param [Integer] id Contact ID
      # @return [Hashie::Mash] Contact record
      # @example Get a contact:
      #   SageOne.contact(12345)
      def contact(id)
        get("contacts/#{id}")
      end
    end
  end
end