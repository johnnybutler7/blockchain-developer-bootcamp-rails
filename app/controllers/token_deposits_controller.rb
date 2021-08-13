class TokenDepositsController < ApplicationController
  def create
    Blockchain::TokenDepositor.new(amount:Ethereum::Formatter.new.to_wei(params[:token_amount].to_i)).call

    redirect_to accounts_path, notice: 'Successfully deposited Tokens'
  end
end