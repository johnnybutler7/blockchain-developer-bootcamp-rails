class TokenWithdrawalsController < ApplicationController
  def create
    Blockchain::TokenWithdrawer.new(amount:Ethereum::Formatter.new.to_wei(params[:token_amount].to_i)).call

    redirect_to accounts_path, notice: 'Successfully withdrew Tokens'
  end
end