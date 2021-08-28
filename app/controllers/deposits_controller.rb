class DepositsController < ApplicationController
  def create
    ether_deposit = Dapp::EtherDeposit.new(amount: Ethereum::Formatter.new.to_wei(ether_amount))
    result = Blockchain::Runner.new(transaction: ether_deposit).run

    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @dapp_status = Dapp::Status.new
          @notice_at = Time.now
        }
        format.html { redirect_to accounts_path, notice: 'Successfully deposited Ether' }  
      else
        format.html { redirect_to accounts_path, notice: "There was a problem depositing Ether - #{result.error}" }
      end
    end
  end

  private

  def ether_amount
    params[:ether_amount].to_i
  end
end