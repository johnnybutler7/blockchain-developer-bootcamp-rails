require "rails_helper"

RSpec.feature 'Cancel Order', :type => :system do

  it "Enables me to cancel an order" do
    visit accounts_path
    click_on "Orders"
    cancel_order_link  = first(:button, "X")
    cancel_order_id = cancel_order_link["data-order-id"] 
    
    cancel_order_link.click
    
    within('.notices') do
      expect(page).to have_content('Order successfully cancelled')
    end
    click_on "Orders"
    within('#my-orders') do
      expect(page).to_not have_selector(:css, "tr#cancel-order-#{cancel_order_id}")
    end
  end
end