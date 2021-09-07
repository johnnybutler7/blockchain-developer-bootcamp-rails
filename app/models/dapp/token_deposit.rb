module Dapp
  class TokenDeposit
    def initialize(amount:)
      @amount = amount
    end

    def run
      TOKEN.transact_and_wait.approve(EXCHANGE.address, amount)
      EXCHANGE.transact_and_wait.deposit_token(TOKEN.address, amount)
    end
    
    def description
      "depositing Tokens"
    end

    private
  
    attr_reader :amount
  end
end