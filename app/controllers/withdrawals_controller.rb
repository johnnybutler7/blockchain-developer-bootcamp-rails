class WithdrawalsController < ApplicationController
  
  def create
    ether_withdraw = Dapp::EtherWithdraw.new(amount: Ethereum::Formatter.new.to_wei(ether_amount))
    result = Blockchain::Runner.new(transaction: ether_withdraw).run
    @notice_at = Time.now

    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @dapp_status = Dapp::Status.new
        }
        format.html { redirect_to dapp_path, notice: 'Successfully withdrew Ether' }  
      else
        format.html { redirect_to dapp_path, notice: "There was a problem withdrawing Ether - #{result.error}" }
        format.turbo_stream do
            render turbo_stream: turbo_stream.append("toasts", partial: "shared/toast",
               locals: { message: "There was a problem withdrawing Ether - #{result.error}", notice_at: @notice_at })
          end
      end
    end
  end
  
  private
  
  def ether_amount
    params[:ether_amount].to_d
  end
end