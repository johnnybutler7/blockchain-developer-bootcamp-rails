class WithdrawalsController < ApplicationController
  
  def create
    respond_to do |format|
      format.turbo_stream {
        @dapp_status = Dapp::Status.new
      }
      format.html { redirect_to dapp_path, notice: 'Successfully withdrew Ether' } 
    end
  end
  
  private
  
  def ether_amount
    params[:ether_amount].to_d
  end
end