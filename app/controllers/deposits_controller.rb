class DepositsController < ApplicationController
  def create
    respond_to do |format|
      format.turbo_stream {
        @dapp_status = Dapp::Status.new
      }
      format.html { redirect_to dapp_path, notice: 'Successfully deposited Ether' }  
    end
  end
end