class AccountController < ApplicationController
  def show
    respond_to do |format|
      format.json { render json: { account: BlOCKCHAIN_CLIENT.default_account } }
    end
  end
  
  def update
    BlOCKCHAIN_CLIENT.default_account = params[:account]
    
    respond_to do |format|
      format.turbo_stream { }
    end
  end
end