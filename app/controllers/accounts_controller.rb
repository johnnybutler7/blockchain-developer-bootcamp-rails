class AccountsController < ApplicationController
  def index
    @account = BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
    @ether_balance = Ethereum::Formatter.new.from_wei(BlOCKCHAIN_CLIENT.eth_get_balance(@account)['result'].hex)
    @exchange_ether_balance = Ethereum::Formatter.new.from_wei(EXCHANGE.call.balance_of(ENV['ETHER_ADDRESS'], @account))
    @token_balance = TOKEN.call.balance_of(@account)
    @exchange_token_balance = EXCHANGE.call.balance_of(TOKEN.address, @account)

    trade_events = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').call
    @trades = Blockchain::Events.new(events: trade_events).trades
    
    order_events = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Order').call
    open_orders = Blockchain::Events.new(events: order_events).open_orders
    @sell_orders = open_orders.find_all{|o| o[:orderType] == 'sell'}
    @buy_orders = open_orders.find_all{|o| o[:orderType] == 'buy'}
  end
end