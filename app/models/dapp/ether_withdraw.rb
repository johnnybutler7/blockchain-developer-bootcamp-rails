module Dapp
  class EtherWithdraw
    def initialize(amount:)
      @amount = amount
    end

    def run
      EXCHANGE.transact_and_wait.withdraw_ether(amount)
    end
    
    def description
      "withdrawing Ether"
    end

    private
  
    attr_reader :amount
  end
end