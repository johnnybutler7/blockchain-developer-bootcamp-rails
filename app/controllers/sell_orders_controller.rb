class SellOrdersController < ApplicationController
  def create    
    sell_order = Dapp::SellOrder.new(params: params)
    result = Blockchain::Runner.new(transaction: sell_order).run
    
    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @notice_at = Time.now
          @order = result.response
        }
        format.html { redirect_to dapp_path, notice: 'Sell order successfully placed' }  
      else
        format.html { redirect_to dapp_path, notice: "There was a problem placing your sell order - #{result.error}" }
      end
    end
  end
end