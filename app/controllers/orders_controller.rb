class OrdersController < ApplicationController
  def create    
    tokenAmount = params[:buy_amount]
    price = params[:buy_price]
   
    tokenGet = TOKEN.address
    tokenGive = ENV['ETHER_ADDRESS']
    amountGet =  Ethereum::Formatter.new.to_wei(tokenAmount.to_i)
    amountGive =  Ethereum::Formatter.new.to_wei(tokenAmount.to_i * price.to_f)
    
    EXCHANGE.transact_and_wait.make_order(tokenGet, amountGet, tokenGive, amountGive)
    
    redirect_to accounts_path, notice: 'Buy order successfully placed'
  end
  
  def fill
    EXCHANGE.transact_and_wait.fill_order(order_id)
    
    redirect_to accounts_path, notice: 'Order successfully filled'
  end
  
  def cancel
    EXCHANGE.transact_and_wait.cancel_order(order_id)
    
    redirect_to accounts_path, notice: 'Order successfully cancelled'
  end
  
  private
  
  def order_id
    params[:order_id].to_i
  end
end