require "rails_helper"

RSpec.feature 'Deposit Token', :type => :system do

  it "Enables me to deposit Tokens" do
    deposit_token_amount = 100
    
    visit root_path
    start_token_amount = find('#deposit-exchange-token-balance').text.to_i
    within('#token-deposit-form') do
      fill_in 'token_amount', with: deposit_token_amount
      click_on 'Deposit'
    end
    
    within('.notices') do
      expect(page).to have_content('Successfully deposited Tokens')
    end
    within('#deposit-exchange-token-balance') do
      expect(page).to have_content((start_token_amount + deposit_token_amount).to_i)
    end
  end
end