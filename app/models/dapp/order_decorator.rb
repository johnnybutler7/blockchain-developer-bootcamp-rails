module Dapp
  class OrderDecorator
    def initialize(item:)
      @item = item
    end

    def decorate
      ether_amount, token_amount = extract_ether_token_amount
      token_price = calculate_token_price(ether_amount, token_amount)
  
      Dapp::Order.new(order_id: order_id,
                      ether_amount: Ethereum::Formatter.new.from_wei(ether_amount),
                      token_amount: Ethereum::Formatter.new.from_wei(token_amount),
                      token_price: token_price,
                      order_type: order_type,
                      user: user)
    end
    
    private
    
    attr_reader :item
    
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

    def extract_ether_token_amount
      if token_give == ENV['ETHER_ADDRESS']
        etherAmount = args[5]
        tokenAmount = args[3]
      else
        etherAmount = args[3]
        tokenAmount = args[5]
      end
      [etherAmount, tokenAmount]
    end

    def calculate_token_price(etherAmount, tokenAmount)
      tokenPrice = (etherAmount.to_f / tokenAmount.to_f)
      tokenPrice = (tokenPrice * PRECISION).round / PRECISION.to_f
    end

    def order_type
      order[4] == ENV['ETHER_ADDRESS'] ? 'buy' : 'sell'
    end
  end
end