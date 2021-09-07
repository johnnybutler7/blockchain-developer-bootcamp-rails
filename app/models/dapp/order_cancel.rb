module Dapp
  class OrderCancel
    def initialize(order_id:)
      @order_id = order_id
    end

    def run
      EXCHANGE.transact_and_wait.cancel_order(order_id)
    end
    
    def description
      "cancelling your order"
    end

    private
  
    attr_reader :order_id
  end
end