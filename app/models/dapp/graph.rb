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
      data = []
      grouped_orders = orders.group_by{|o| o.formatted_timestamp.beginning_of_hour }
      hours = grouped_orders.keys
      hours.each do |hour|
        group = grouped_orders[hour]
        open = group[0].token_price
        high = group.map(&:token_price).max
        low = group.map(&:token_price).min
        close = group.last.token_price
        formatted_time = hour.to_i * 1000
      
        data << [formatted_time, [open, high, low, close]]
      end
      data
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