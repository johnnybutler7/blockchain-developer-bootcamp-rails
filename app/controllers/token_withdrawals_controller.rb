class TokenWithdrawalsController < ApplicationController
  def create
    respond_to do |format|
      format.turbo_stream {
        @dapp_status = Dapp::Status.new
      }
      format.html { redirect_to dapp_path, notice: 'Successfully withdrew Tokens' }  
    end
  end
  
  private
  
  def token_amount
    params[:token_amount].to_i
  end
end