class AccountsController < ApplicationController
  def index
    @dapp_status = Dapp::Status.new

    trade_events = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').call
    @trades = Blockchain::Events.new(events: trade_events).trades
    
    order_events = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Order').call
    open_orders = Blockchain::Events.new(events: order_events).open_orders
    @sell_orders = open_orders.find_all{|o| o[:orderType] == 'sell'}
    @buy_orders = open_orders.find_all{|o| o[:orderType] == 'buy'}

    @my_orders = open_orders.find_all{|o| o[:user] == @current_account}
    @my_trades = @trades.find_all{|o| o[:user] == @current_account || o[:userFill] == @current_account}
  end
end