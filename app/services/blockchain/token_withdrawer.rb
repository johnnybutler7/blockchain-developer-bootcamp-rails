module Blockchain
  class TokenWithdrawer
    def initialize(amount:)
      @amount = amount
    end
  
    def call
      EXCHANGE.transact_and_wait.withdraw_token(TOKEN.address, amount)
    end
  
    private
  
    attr_reader :amount
  end
end