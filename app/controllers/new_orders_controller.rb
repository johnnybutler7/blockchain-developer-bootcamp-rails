class NewOrdersController < ApplicationController
  def create
    client = Ethereum::HttpClient.new('http://localhost:7545')
    truffle_path = Dir.pwd
    exchange = Ethereum::Contract.create(name: "Exchange", truffle: { paths: [ truffle_path ] }, client: client)
    token = Ethereum::Contract.create(name: "Token", truffle: { paths: [ truffle_path ] }, client: client)
    
    tokenAmount = params[:buy_amount]
    price = params[:buy_price]
   
    tokenGet = token.address
    tokenGive = '0000000000000000000000000000000000000000'
    amountGet =  Ethereum::Formatter.new.to_wei(tokenAmount.to_i)
    amountGive =  Ethereum::Formatter.new.to_wei(tokenAmount.to_i * price.to_f)
    
    exchange.transact_and_wait.make_order(tokenGet, amountGet, tokenGive, amountGive)
  end
end