module Dapp
  class Trade
    attr_reader :order_id, :ether_amount, :token_amount, :token_price, :formatted_timestamp,
                :order_type, :order_sign, :user, :user_fill
    
    def initialize(order_id:, ether_amount:, token_amount:, token_price:, formatted_timestamp:,
                   order_type:, order_sign:, user:, user_fill:)
      
      @order_id = order_id
      @ether_amount = ether_amount
      @token_amount = token_amount
      @token_price = token_price
      @formatted_timestamp = formatted_timestamp
      @order_type = order_type
      @order_sign = order_sign
      @user = user
      @user_fill = user_fill
    end
  end
end