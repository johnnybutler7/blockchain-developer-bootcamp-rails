module Dapp
  class Order
    attr_reader :order_id, :ether_amount, :token_amount,
                :token_price, :order_type, :user
    
    def initialize(order_id:, ether_amount:, token_amount:, token_price:,
                   order_type:, user:)
      
      @order_id = order_id
      @ether_amount = ether_amount
      @token_amount = token_amount
      @token_price = token_price
      @order_type = order_type
      @user = user
    end
  end
end