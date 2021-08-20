require "rails_helper"

RSpec.feature 'Cancel Order', :type => :system do

  it "Enables me to cancel an order" do
    visit accounts_path
    click_on "Orders"
    cancel_order_link  = first(:link, "X")
    cancel_order_id = cancel_order_link["data-order-id"] 
    
    cancel_order_link.click
    click_on "Orders"
    
    expect(page).to have_content('Order successfully cancelled')
    within('#my-orders') do
      expect(page).to_not have_selector(:css, "tr#cancel-order-#{cancel_order_id}")
    end
  end
end