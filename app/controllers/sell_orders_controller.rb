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
        format.html { redirect_to accounts_path, notice: 'Sell order successfully placed' }  
      else
        format.html { redirect_to accounts_path, notice: "There was a problem placing your sell order - #{result.error}" }
      end
    end
  end
  
  
  # def create
 #    tokenAmount = params[:sell_amount]
 #    price = params[:sell_price]
 #
 #    tokenGet = ENV['ETHER_ADDRESS']
 #    amountGet =  Ethereum::Formatter.new.to_wei(tokenAmount.to_i * price.to_f)
 #    tokenGive = TOKEN.address
 #    amountGive = Ethereum::Formatter.new.to_wei(tokenAmount.to_i)
 #
 #    EXCHANGE.transact_and_wait.make_order(tokenGet, amountGet, tokenGive, amountGive)
 #
 #    redirect_to accounts_path, notice: 'Sell order successfully placed'
 #  end
end