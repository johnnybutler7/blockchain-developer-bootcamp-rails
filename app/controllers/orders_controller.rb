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
    order_fill = Dapp::OrderFill.new(order_id: @order_id)
    result = Blockchain::Runner.new(transaction: order_fill).run
  
    respond_to do |format|
      if result.success?
        @trade = result.response
        @dapp_status = Dapp::Status.new
        @notice_at = Time.now

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