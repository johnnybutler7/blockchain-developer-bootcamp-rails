require "rails_helper"

RSpec.feature 'Withdraw Tokens', :type => :system do

  it "Enables me to deposit Tokens" do
    withdraw_token_amount = 100
    
    visit accounts_path
    start_token_amount = find('#exchange-token-balance').text.to_f
    within('#withdraw-token-form') do
      fill_in 'token_amount', with: withdraw_token_amount
      click_on 'Withdraw'
    end
    
    expect(page).to have_content('Successfully withdrew Tokens')
    within('#exchange-token-balance') do
      expect(page).to have_content((start_token_amount - withdraw_token_amount).to_i)
    end
  end
end