class AccountsController < ApplicationController
  
  def index
    client = Ethereum::HttpClient.new('http://localhost:7545')
    truffle_path = Dir.pwd#'/Users/johnbutler/git_projects/dapps/blockchain-developer-bootcamp'
    exchange = Ethereum::Contract.create(name: "Exchange", truffle: { paths: [ truffle_path ] }, client: client)
    @account = client.eth_accounts['result'][0]
    @balance = Ethereum::Formatter.new.from_wei(client.eth_get_balance(@account)['result'].hex)
    @trades = decorated_trades(Blockchain::Logs.get_logs(exchange, 'Trade'))
  end
  
  def decorated_trades(events)
    trades = []
    precision = 100000
    events.each do |event|
      args = event[:args]
      tokenGive = args[4]
      if tokenGive == '0000000000000000000000000000000000000000'
        etherAmount = args[5]
        tokenAmount = args[3]
      else
        etherAmount = args[3]
        tokenAmount = args[5]
      end
      
      tokenPrice = (etherAmount.to_f / tokenAmount.to_f)
      tokenPrice = (tokenPrice * precision).round / precision.to_f
      formattedTimestamp = Time.at(args[7])
      
      trades << {etherAmount: etherAmount, tokenAmount: Ethereum::Formatter.new.from_wei(tokenAmount), tokenPrice: tokenPrice, formattedTimestamp: formattedTimestamp}
    end
    trades
  end
end