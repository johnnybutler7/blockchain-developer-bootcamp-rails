class DepositsController < ApplicationController
  def create
    ether_deposit = Blockchain::EtherDepositor.new(amount: Ethereum::Formatter.new.to_wei(ether_amount)).call
    
    if ether_deposit.success?
      redirect_to accounts_path, notice: 'Successfully deposited Ether'
    else
      redirect_to accounts_path, notice: "There was a problem depositing Ether - #{ether_deposit.error}"
    end
  end
  
  private
  
  def ether_amount
    params[:ether_amount].to_i
  end
end