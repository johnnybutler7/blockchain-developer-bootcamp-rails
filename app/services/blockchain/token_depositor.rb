module Blockchain
  class TokenDepositor
    def initialize(amount:)
      @amount = amount
    end
  
    def call
      TOKEN.transact_and_wait.approve(EXCHANGE.address, amount)
      EXCHANGE.transact_and_wait.deposit_token(TOKEN.address, amount)
    end
  
    private
  
    attr_reader :amount
  end
end