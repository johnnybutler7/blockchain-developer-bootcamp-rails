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
    @order_id = order_id
    order_fill = Blockchain::OrderFiller.new(order_id: order_id).call
    
    @trade = order_fill.response
    @ether_balance = Ethereum::Formatter.new.from_wei(BlOCKCHAIN_CLIENT.eth_get_balance(@current_account)['result'].hex)
    @exchange_ether_balance = Ethereum::Formatter.new.from_wei(EXCHANGE.call.balance_of(ENV['ETHER_ADDRESS'], @current_account))
    @notice_at = Time.now

    respond_to do |format|
      if order_fill.success?
        format.turbo_stream {}
        format.html { redirect_to accounts_path, notice: 'Order successfully filled' }  
      else
        format.html { redirect_to accounts_path, notice: "There was a problem fulfilling your order - #{order_fill.error}" }
      end
    end
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