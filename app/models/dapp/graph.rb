module Dapp
  class Graph
    def initialize(orders:)
      @orders = orders
    end
    
    def last_price_change
      last_price >= second_last_price ? '+' : '-'
    end
    
    def last_price
      last_order.token_price
    end

    def series_data
      grouped_orders = orders.group_by{|o| o.formatted_timestamp.beginning_of_hour }
      Dapp::GraphDataBuilder.new(orders: grouped_orders).call
    end

    private
  
    attr_reader :orders

    def second_last_price
      second_last_order.token_price
    end
    
    def last_order
      orders.last
    end
    
    def second_last_order
      orders.slice(-2)
    end
  end
end