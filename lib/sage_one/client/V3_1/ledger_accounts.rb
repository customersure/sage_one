module SageOne
  class Client
    module V3_1
      # module SageOne::Client::V3::BankAccounts
      module LedgerAccounts
        # List BankAccounts
        # @param options [Hash] A customizable set of options.
        # @return [Array<BankAccount>] A list of all BankAccounts. Each BankAccount is a Hashie.
        # @example Get all BankAccounts
        #   SageOne.ledger_accounts
        def ledger_accounts(options = {})
          get('ledger_accounts', options)
        end

        def create_ledger_account(options)
          post('ledger_accounts', ledger_account: options)
        end
      end
    end
  end
end
