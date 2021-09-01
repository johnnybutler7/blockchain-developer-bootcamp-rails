class AccountsController < ApplicationController
  def index
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
  end
end