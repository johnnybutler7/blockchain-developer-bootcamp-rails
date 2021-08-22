class DepositsController < ApplicationController
  def create
    ether_deposit = Blockchain::EtherDepositor.new(amount: Ethereum::Formatter.new.to_wei(ether_amount)).call

    @ether_balance = Ethereum::Formatter.new.from_wei(BlOCKCHAIN_CLIENT.eth_get_balance(@current_account)['result'].hex)
    @exchange_ether_balance = Ethereum::Formatter.new.from_wei(EXCHANGE.call.balance_of(ENV['ETHER_ADDRESS'], @current_account))

    respond_to do |format|
      if ether_deposit.success?
        format.turbo_stream {}
        format.html { redirect_to accounts_path, notice: 'Successfully deposited Ether' }  
      else
        format.html { redirect_to accounts_path, notice: "There was a problem depositing Ether - #{ether_deposit.error}" }
      end
    end
  end

  private

  def ether_amount
    params[:ether_amount].to_i
  end
end