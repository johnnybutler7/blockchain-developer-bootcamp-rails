module Dapp
  class Status
    def ether_balance
      Ethereum::Formatter.new.from_wei(BlOCKCHAIN_CLIENT.eth_get_balance(account)['result'].hex)
    end
    
    def exchange_ether_balance
      Ethereum::Formatter.new.from_wei(EXCHANGE.call.balance_of(ENV['ETHER_ADDRESS'], account))
    end

    def token_balance
      TOKEN.call.balance_of(account)
    end
    
    def exchange_token_balance
      EXCHANGE.call.balance_of(TOKEN.address, account)
    end
    
    private
    
    def account
      BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
    end
  end
end

