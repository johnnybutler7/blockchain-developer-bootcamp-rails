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
    prev_token_price = params[:prev_token_price].to_d
    order_fill = Dapp::OrderFill.new(order_id: @order_id, prev_token_price: prev_token_price)
    result = Blockchain::Runner.new(transaction: order_fill).run

    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @trade = result.response
          @dapp_status = Dapp::Status.new
        }
        format.html { redirect_to accounts_path, notice: 'Order successfully filled' }  
      else
        format.html { redirect_to accounts_path, notice: "There was a problem fulfilling your order - #{result.error}" }
      end
    end
  end
  
  def cancel
    @order_id = order_id
    order_cancel = Dapp::OrderCancel.new(order_id: @order_id)
    result = Blockchain::Runner.new(transaction: order_cancel).run

    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @notice_at = Time.now
        }
        format.html { redirect_to accounts_path, notice: 'Order successfully cancelled' }  
      else
        format.html { redirect_to accounts_path, notice: "There was a problem cancelling your order - #{result.error}" }
      end
    end
  end
  
  private
  
  def order_id
    params[:order_id].to_i
  end
  
  def fill_order_params
    params.permit(:prev_token_price)
  end
end