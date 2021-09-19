class SellOrdersController < ApplicationController
  def create    
    sell_order = Dapp::SellOrder.new(transaction_hash: params[:transaction_hash])
    result = Blockchain::Runner.new(transaction: sell_order).run
    
    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @order = result.response
        }
        format.html { redirect_to dapp_path, notice: 'Sell order successfully placed' }  
      else
        @error_message = result.error_message
        format.html { redirect_to dapp_path, notice: @error_message }
        format.turbo_stream { render 'shared/turbo_error' }
      end
    end
  end
end