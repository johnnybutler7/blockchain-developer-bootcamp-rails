module Blockchain
  class EtherWithdrawer
    def initialize(amount:)
      @amount = amount
    end
  
    def call
      EXCHANGE.transact_and_wait.withdraw_ether(amount)
    end
  
    private
  
    attr_reader :amount
  end
end