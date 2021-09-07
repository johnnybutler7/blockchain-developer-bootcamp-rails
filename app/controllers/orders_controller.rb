class OrdersController < ApplicationController
  def create    
    buy_order = Dapp::BuyOrder.new(params: params)
    result = Blockchain::Runner.new(transaction: buy_order).run
    
    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @order = result.response
        }
        format.html { redirect_to dapp_path, notice: 'Buy order successfully placed' }  
      else
        @error_message = result.error_message
        format.html { redirect_to dapp_path, notice: @error_message }
        format.turbo_stream { render 'shared/turbo_error' }
      end
    end
  end
  
  def update
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
        format.html { redirect_to dapp_path, notice: 'Order successfully filled' }  
      else
        @error_message = result.error_message
        format.html { redirect_to dapp_path, notice: @error_message}
        format.turbo_stream { render 'shared/turbo_error' }
      end
    end
  end
  
  def destroy
    @order_id = order_id
    order_cancel = Dapp::OrderCancel.new(order_id: @order_id)
    result = Blockchain::Runner.new(transaction: order_cancel).run

    respond_to do |format|
      if result.success?
        format.turbo_stream {}
        format.html { redirect_to dapp_path, notice: 'Order successfully cancelled' }  
      else
        @error_message = result.error_message
        format.html { redirect_to dapp_path, notice: @error_message }
        format.turbo_stream { render 'shared/turbo_error' }
      end
    end
  end
  
  private
  
  def order_id
    params[:id].to_i
  end
end