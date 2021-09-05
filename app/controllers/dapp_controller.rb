class DappController < ApplicationController
  def show
    @dapp_status = Dapp::Status.new

    exchange_trade_log = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').call
    @trades = Dapp::TradesDecorator.new(items: exchange_trade_log).call
    
    exchange_order_log = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Order').call
    open_orders_log = Dapp::OpenOrdersQuery.new(orders: exchange_order_log).execute
    open_orders = Dapp::TransactionsDecorator.new(items: open_orders_log).call
    
    @sell_orders = open_orders.find_all{|o| o.order_type == 'sell'}
    @buy_orders = open_orders.find_all{|o| o.order_type == 'buy'}

    @my_orders = open_orders.find_all{|o| o.user == @dapp_status.account}
    @my_trades = @trades.find_all{|o| o.user == @dapp_status.account || o.user_fill == @dapp_status.account}
    
    filled_orders = @trades.sort_by(&:formatted_timestamp)
    secondLastOrder, lastOrder = filled_orders.slice(filled_orders.length - 2, filled_orders.length)
    lastPrice = lastOrder.token_price
    secondLastPrice = secondLastOrder.token_price
    lastPriceChange = lastPrice >= secondLastPrice ? '+' : '-'
    grouped_orders = filled_orders.group_by{|o| o.formatted_timestamp.beginning_of_hour }
    hours = grouped_orders.keys
    
    @graph_data = []
    hours.each do |hour|
      group = grouped_orders[hour]
      open = group[0].token_price
      high = group.map(&:token_price).max
      low = group.map(&:token_price).min
      close = group.last.token_price
      formatted_time = hour.to_i * 1000
      
      @graph_data << [formatted_time, [open, high, low, close]]
    end
    
    @graph_data
  end
end
