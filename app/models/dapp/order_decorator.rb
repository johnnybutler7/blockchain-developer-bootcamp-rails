module Dapp
  class OrderDecorator
    def initialize(item:)
      @item = item
    end

    def decorate
      OpenStruct.new(order_attributes)
    end
    
    private
    
    attr_reader :item

    def order_attributes
      financials = transaction_financials
      {
        order_id: order_id,
        ether_amount: Ethereum::Formatter.new.from_wei(financials.ether_amount),
        token_amount: Ethereum::Formatter.new.from_wei(financials.token_amount),
        token_price: transaction_financials.token_price,
        order_type: order_type,
        user: user
      }
    end
    
    def transaction_financials
      Dapp::TransactionFinancials.new(token_give: token_give, 
                                      amount_get: amount_get, 
                                      amount_give: amount_give)
    end
    
    def args
      item[:args]
    end

    def order_id
      args[0]
    end

    def order
      EXCHANGE.call.orders(order_id)
    end

    def user
      Ethereum::Formatter.new.to_address(args[1])
    end

    def token_give
      args[4]
    end

    def order_type
      token_give == ENV['ETHER_ADDRESS'] ? 'buy' : 'sell'
    end
    
    def amount_get
      args[3]
    end
    
    def amount_give
      args[5]
    end
  end
end