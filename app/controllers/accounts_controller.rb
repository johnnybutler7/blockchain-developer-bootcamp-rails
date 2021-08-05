class AccountsController < ApplicationController
  def index
    @account = BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
    @balance = Ethereum::Formatter.new.from_wei(BlOCKCHAIN_CLIENT.eth_get_balance(@account)['result'].hex)
    
    trade_events = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').call
    @trades = Blockchain::Events.new(events: trade_events).trades
    
    order_events = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Order').call
    open_orders = Blockchain::Events.new(events: order_events).open_orders
    
    @sell_orders = open_orders.find_all{|o| o[:orderType] == 'sell'}
    @buy_orders = open_orders.find_all{|o| o[:orderType] == 'buy'}
  end
end