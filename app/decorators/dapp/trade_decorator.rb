module Dapp
  class TradeDecorator
    def initialize(item:, prev_token_price:)
      @item = item
      @prev_token_price = prev_token_price
    end
    
    def decorate
      OpenStruct.new(trade_attributes)
    end
    
    private
    
    attr_reader :item, :prev_token_price
    
    def trade_attributes
      financials = transaction_financials
      {
        order_id: order_id, 
        ether_amount: financials.ether_amount,
        token_amount: Ethereum::Formatter.new.from_wei(financials.token_amount), 
        token_price: financials.token_price, 
        formatted_timestamp: formatted_timestamp, 
        order_type: order_type, 
        order_sign: order_sign, 
        user: user, 
        user_fill: user_fill,
        trade_direction_class: trade_direction_class(financials.token_price)
      }
    end
    
    def trade_direction_class(token_price)
      return 'text-success' unless prev_token_price
      token_price < prev_token_price ? 'text-danger' : 'text-success'
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
    
    def user_fill
      Ethereum::Formatter.new.to_address(args[6])
    end
    
    def token_give
      args[4]
    end
    
    def order_type
      if user_is_account?
        token_give == ENV['ETHER_ADDRESS'] ? 'buy' : 'sell'
      else
        token_give == ENV['ETHER_ADDRESS'] ? 'sell' : 'buy'
      end
    end
    
    def order_sign
      order_type == 'buy' ? '+' : '-'
    end
    
    def formatted_timestamp
      Time.at(args[7])
    end
    
    def account
      BlOCKCHAIN_CLIENT.default_account
    end
    
    def amount_get
      args[3]
    end
    
    def amount_give
      args[5]
    end
    
    def user_is_account?
      Ethereum::Formatter.new.to_ascii(user) == Ethereum::Formatter.new.to_ascii(account)
    end
  end
end