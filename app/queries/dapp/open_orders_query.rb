module Dapp
  class OpenOrdersQuery
    def initialize(orders:)
      @orders = orders
    end
    
    def execute
      open_orders = []
      orders.each do |order|
        order_id = order[:args][0]
        open_orders << order if !EXCHANGE.call.order_filled(order_id) && !EXCHANGE.call.order_cancelled(order_id)
      end
      open_orders.reverse
    end

    private

    attr_reader :orders
  end
end