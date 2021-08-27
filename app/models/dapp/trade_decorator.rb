module Dapp
  class TradeDecorator
    
    def initialize(trade:)
      @trade = trade
    end
    
    def decorate
      ether_amount, token_amount = extract_ether_token_amount
      token_price = calculate_token_price(ether_amount, token_amount)
      
      Dapp::Trade.new(order_id: order_id, 
                      ether_amount: ether_amount,
                      token_amount: Ethereum::Formatter.new.from_wei(token_amount), 
                      token_price: token_price, 
                      formatted_timestamp: formatted_timestamp, 
                      order_type: order_type, 
                      order_sign: order_sign, 
                      user: user, 
                      user_fill: user_fill)
    end
    
    private
    
    attr_reader :trade
    
    def args
      trade[:args]
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
      myOrder = user == account
      if myOrder
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
      BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
    end
  end
end