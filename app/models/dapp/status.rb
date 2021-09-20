module Dapp
  class Status
      
    attr_reader :ether_balance, :exchange_ether_balance, :token_balance, :exchange_token_balance, :account
    
    def initialize()
      @account = current_account
      @ether_balance = current_ether_balance
      @exchange_ether_balance = current_exchange_ether_balance
      @token_balance = current_token_balance
      @exchange_token_balance = current_exchange_token_balance
    end
    
    private
    
    def current_ether_balance
      Ethereum::Formatter.new.from_wei(BlOCKCHAIN_CLIENT.eth_get_balance(account)['result'].hex)
    end
    
    def current_exchange_ether_balance
      Ethereum::Formatter.new.from_wei(EXCHANGE.call.balance_of(ENV['ETHER_ADDRESS'], account))
    end

    def current_token_balance
      TOKEN.call.balance_of(account)
    end
    
    def current_exchange_token_balance
      EXCHANGE.call.balance_of(TOKEN.address, account)
    end

    def current_account
      BlOCKCHAIN_CLIENT.default_account
    end
  end
end

