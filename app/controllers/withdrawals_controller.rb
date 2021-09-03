class WithdrawalsController < ApplicationController
  
  def create
    ether_withdraw = Dapp::EtherWithdraw.new(amount: Ethereum::Formatter.new.to_wei(ether_amount))
    result = Blockchain::Runner.new(transaction: ether_withdraw).run

    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @dapp_status = Dapp::Status.new
          @notice_at = Time.now
        }
        format.html { redirect_to dapp_path, notice: 'Successfully withdrew Ether' }  
      else
        format.html { redirect_to dapp_path, notice: "There was a problem withdrawing Ether - #{result.error}" }
      end
    end
  end
  
  private
  
  def ether_amount
    params[:ether_amount].to_d
  end
end