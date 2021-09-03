class TokenDepositsController < ApplicationController
  def create
    token_deposit = Dapp::TokenDeposit.new(amount: Ethereum::Formatter.new.to_wei(token_amount))
    result = Blockchain::Runner.new(transaction: token_deposit).run

    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @dapp_status = Dapp::Status.new
          @notice_at = Time.now
        }
        format.html { redirect_to dapp_path, notice: 'Successfully deposited Tokens' }  
      else
        format.html { redirect_to dapp_path, notice: "There was a problem depositing Ether - #{result.error}" }
      end
    end
  end
  
  private
  
  def token_amount
    params[:token_amount].to_i
  end
end