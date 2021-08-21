class ApplicationController < ActionController::Base
  before_action :load_current_account
  
  private
  
  def load_current_account
    @current_account = BlOCKCHAIN_CLIENT.eth_accounts['result'][0]
  end
end
