class TokenWithdrawalsController < ApplicationController
  def create
    token_withdraw = Dapp::TokenWithdraw.new(amount: Ethereum::Formatter.new.to_wei(token_amount))
    result = Blockchain::Runner.new(transaction: token_withdraw).run

    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @dapp_status = Dapp::Status.new
        }
        format.html { redirect_to dapp_path, notice: 'Successfully withdrew Tokens' }  
      else
        @error_message = result.error_message
        format.html { redirect_to dapp_path, notice: @error_message }
        format.turbo_stream { render 'shared/turbo_error' }
      end
    end
  end
  
  private
  
  def token_amount
    params[:token_amount].to_i
  end
end