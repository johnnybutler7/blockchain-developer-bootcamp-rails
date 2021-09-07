module Dapp
  class TokenWithdraw
    def initialize(amount:)
      @amount = amount
    end

    def run
      EXCHANGE.transact_and_wait.withdraw_token(TOKEN.address, amount)
    end
    
    def description
      "withdrawing Tokens"
    end

    private
  
    attr_reader :amount
  end
end