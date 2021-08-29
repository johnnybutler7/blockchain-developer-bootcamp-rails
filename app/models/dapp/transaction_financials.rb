module Dapp
  class TransactionFinancials
    attr_reader :token_give, :amount_get, :amount_give

    def initialize(token_give:, amount_get:, amount_give:)
      @token_give = token_give
      @amount_get = amount_get
      @amount_give = amount_give
    end

    def ether_amount
      token_give_is_contract_address? ? amount_give : amount_get
    end
    
    def token_amount
      token_give_is_contract_address? ? amount_get : amount_give
    end

    def token_price
      price = (ether_amount.to_f / token_amount.to_f)
      (price * PRECISION).round / PRECISION.to_f
    end
    
    private
    
    def token_give_is_contract_address?
      token_give == ENV['ETHER_ADDRESS'] 
    end
  end
end