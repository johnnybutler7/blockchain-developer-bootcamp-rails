class AccountsController < ApplicationController
  def index
    @ether_balance = Ethereum::Formatter.new.from_wei(BlOCKCHAIN_CLIENT.eth_get_balance(@current_account)['result'].hex)
    @exchange_ether_balance = Ethereum::Formatter.new.from_wei(EXCHANGE.call.balance_of(ENV['ETHER_ADDRESS'], @current_account))
    @token_balance = TOKEN.call.balance_of(@current_account)
    @exchange_token_balance = EXCHANGE.call.balance_of(TOKEN.address, @current_account)

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