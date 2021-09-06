module Dapp
  class GraphDataBuilder
    def initialize(orders:)
      @orders = orders
    end

    def call
      data = []
      hours.each do |hour|
        data << data_row(hour)
      end
      data
    end

    private

    attr_reader :orders
    
    def hours
      orders.keys
    end
    
    def data_row(hour)
      group = orders[hour]
      open = group[0].token_price
      high = group.map(&:token_price).max
      low = group.map(&:token_price).min
      close = group.last.token_price
      formatted_time = hour.to_i * 1000
      
      [formatted_time, [open, high, low, close]]
    end
  end
end