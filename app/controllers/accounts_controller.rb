class AccountsController < ApplicationController
  def index
    @dapp_status = Dapp::Status.new

    exchange_trade_log = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').call
    @trades = Dapp::Trades.new(trades: exchange_trade_log).decorate
    
    order_events = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Order').call
    open_orders = Blockchain::Events.new(events: order_events).open_orders
    @sell_orders = open_orders.find_all{|o| o[:orderType] == 'sell'}
    @buy_orders = open_orders.find_all{|o| o[:orderType] == 'buy'}

    @my_orders = open_orders.find_all{|o| o[:user] == @dapp_status.account}
    @my_trades = @trades.find_all{|o| o.user == @dapp_status.account || o.user_fill == @dapp_status.account}
  end
end