class WithdrawalsController < ApplicationController
  def create
    Blockchain::EtherWithdrawer.new(amount: Ethereum::Formatter.new.to_wei(params[:ether_amount].to_i)).call

    redirect_to accounts_path, notice: 'Successfully withdrew Ether'
  end
end