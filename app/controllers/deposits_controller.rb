class DepositsController < ApplicationController
  def create
    ether_deposit = Dapp::EtherDeposit.new(amount: Ethereum::Formatter.new.to_wei(ether_amount))
    result = Blockchain::Runner.new(transaction: ether_deposit).run

    respond_to do |format|
      if result.success?
        format.turbo_stream {
          @dapp_status = Dapp::Status.new
        }
        format.html { redirect_to dapp_path, notice: 'Successfully deposited Ether' }  
      else
        @error_message = result.error_message
        format.html { redirect_to dapp_path, notice: @error_message }
        format.turbo_stream { render 'shared/turbo_error' }
      end
    end
  end

  private

  def ether_amount
    params[:ether_amount].to_d
  end
end