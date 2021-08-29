class TokenWithdrawalsController < ApplicationController
  def create
    token_withdraw = Dapp::TokenWithdraw.new(amount: Ethereum::Formatter.new.to_wei(token_amount))
    result = Blockchain::Runner.new(transaction: token_withdraw).run

    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @dapp_status = Dapp::Status.new
          @notice_at = Time.now
        }
        format.html { redirect_to accounts_path, notice: 'Successfully withdrew Tokens' }  
      else
        format.html { redirect_to accounts_path, notice: "There was a problem withdrawing your Tokens - #{result.error}" }
      end
    end
  end
  
  private
  
  def token_amount
    params[:token_amount].to_i
  end
  # def create
#     Blockchain::TokenWithdrawer.new(amount:Ethereum::Formatter.new.to_wei(params[:token_amount].to_i)).call
#
#     redirect_to accounts_path, notice: 'Successfully withdrew Tokens'
#   end
end