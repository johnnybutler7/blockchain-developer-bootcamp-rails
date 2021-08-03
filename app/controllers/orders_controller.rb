class OrdersController < ApplicationController
  def create    
    tokenAmount = params[:buy_amount]
    price = params[:buy_price]
   
    tokenGet = TOKEN.address
    tokenGive = ENV['ETHER_ADDRESS']
    amountGet =  Ethereum::Formatter.new.to_wei(tokenAmount.to_i)
    amountGive =  Ethereum::Formatter.new.to_wei(tokenAmount.to_i * price.to_f)
    
    EXCHANGE.transact_and_wait.make_order(tokenGet, amountGet, tokenGive, amountGive)
    
    redirect_to accounts_path, notice: 'Order successfully placed'
  end
  
  def fill
  end
end