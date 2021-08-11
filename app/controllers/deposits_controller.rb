class DepositsController < ApplicationController
  def create
    Blockchain::EtherDepositor.new(amount: Ethereum::Formatter.new.to_wei(params[:ether_amount].to_i)).call

    redirect_to accounts_path, notice: 'Successfully deposited Ether'
  end
end