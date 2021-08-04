class SellOrdersController < ApplicationController
  def create    
    tokenAmount = params[:sell_amount]
    price = params[:sell_price]
    
    tokenGet = ENV['ETHER_ADDRESS']
    amountGet =  Ethereum::Formatter.new.to_wei(tokenAmount.to_i * price.to_f)
    tokenGive = TOKEN.address
    amountGive = Ethereum::Formatter.new.to_wei(tokenAmount.to_i)
     
    EXCHANGE.transact_and_wait.make_order(tokenGet, amountGet, tokenGive, amountGive)
  
    redirect_to accounts_path, notice: 'Sell order successfully placed'
  end
end