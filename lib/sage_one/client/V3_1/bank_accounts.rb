module SageOne
  class Client
    module V3_1
      # module SageOne::Client::V3::BankAccounts
      module BankAccounts
        # List BankAccounts
        # @param options [Hash] A customizable set of options.
        # @return [Array<BankAccount>] A list of all BankAccounts. Each BankAccount is a Hashie.
        # @example Get all BankAccounts
        #   SageOne.bank_accounts
        def bank_accounts(options = {})
          get('bank_accounts', options)
        end

        # Create a BankAccount.
        # @param options [Hash] A customizable set of options. Note that you don't have to wrap these,
        #                       i.e. { bank_account: {options} }, just pass in the options hash.
        # @return [BankAccount] A Hashie of the created BankAccount.
        def create_bank_account(options)
          post('bank_accounts', bank_account: options)
        end

        # Get a BankAccount record by ID
        # @param [Integer] id BankAccount ID
        # @return [Hashie::Mash] BankAccount record
        # @example Get a BankAccount:
        #   SageOne.bank_account(12345)
        def bank_account(id)
          get("bank_accounts/#{id}")
        end

        # Update a BankAccount
        # @param id [Integer] The id of the BankAccount you want to update.
        # @param (see #create_bank_account)
        # @return [BankAccount] A Hashie of the updated BankAccount.
        def update_bank_account(id, options)
          put("bank_accounts/#{id}", bank_account: options)
        end

        # Delete a BankAccount.
        # @param id [Integer] The id of the BankAccount you want to delete.
        # @return [BankAccount] A Hashie of the deleted BankAccount
        # @example Delete an BankAccount
        #    bank_account = SageOne.delete_bank_account!(12)
        def delete_bank_account!(id)
          delete("bank_accounts/#{id}")
        end
      end
    end
  end
end
