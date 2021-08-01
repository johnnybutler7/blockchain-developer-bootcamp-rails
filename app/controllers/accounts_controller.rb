class AccountsController < ApplicationController
  def index
    @account = BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
    @balance = Ethereum::Formatter.new.from_wei(BlOCKCHAIN_CLIENT.eth_get_balance(@account)['result'].hex)
    @trades = Blockchain::Events.new(events: Blockchain::Logs.get_logs(EXCHANGE, 'Trade')).trades
  end
end