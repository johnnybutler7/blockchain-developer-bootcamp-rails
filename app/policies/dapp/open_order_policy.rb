module Dapp
  class OpenOrderPolicy
    def initialize(order_id:)
      @order_id = order_id
    end
    
    def open?
      !filled? && !cancelled?
    end

    private

    attr_reader :order_id
    
    def filled?
      EXCHANGE.call.order_filled(order_id)
    end
    
    def cancelled?
      EXCHANGE.call.order_cancelled(order_id)
    end
  end
end