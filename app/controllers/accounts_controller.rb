class AccountsController < ApplicationController
  def index
    @account = BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
    @balance = Ethereum::Formatter.new.from_wei(BlOCKCHAIN_CLIENT.eth_get_balance(@account)['result'].hex)
    
    trade_events = Blockchain::Logs.new(contract: EXCHANGE, event_name: 'Trade').call
    @trades = Blockchain::Events.new(events: trade_events).trades
  end
end