# spec/features/manage_menu_items_spec.rb

require 'rails_helper'

RSpec.feature "ManageMenuItems", type: :feature do
  let(:restaurant) { Restaurant.create!(name: "Test Restaurant", address: "123 Test St.", phone_number: "123-456-7890") }

  scenario "Restaurant owner creates a new menu item" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: "Pizza"
    fill_in "Price", with: "10.0"
    
    # Setting the Category and Spiciness using select dropdowns based on the enums
    select "appetizer", from: "menu_item[category]"
    select "mild", from: "Spiciness"
    
    click_button "Create Menu item"
  
    expect(page).to have_text("Menu item was successfully created.")
    expect(page).to have_text("Pizza")
    expect(page).to have_text("$10.0")
  end
  

  scenario "Restaurant owner tries to create an invalid menu item" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: ""
    fill_in "Price", with: "-5"
    click_button "Create Menu item"

    expect(page).to have_text("Name can't be blank")
    expect(page).to have_text("Price must be greater than 0")
  end

  scenario "Menu item availability updates based on stock" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: "Burger"
    fill_in "Price", with: "7.0"
    fill_in "Stock", with: "5"
    click_button "Create Menu item"

    menu_item = MenuItem.find_by(name: "Burger")
    expect(menu_item.availability).to be_truthy

    # Simulate the stock going to 0 (perhaps this could be done via some user action)
    menu_item.update(stock: 0)
    expect(menu_item.availability).to be_falsey
  end

  scenario "Menu item displays discounted price" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: "Salad"
    fill_in "Price", with: "5.0"
    fill_in "Discount", with: "10"
    click_button "Create Menu item"

    expect(page).to have_text("Menu item was successfully created.")
    expect(page).to have_text("Salad")
    expect(page).to have_text("$4.5")  # Discounted price
  end

  scenario "Menu item displays regular price when no discount" do
    visit new_restaurant_menu_item_path(restaurant)
    fill_in "Name", with: "Pasta"
    fill_in "Price", with: "8.0"
    click_button "Create Menu item"

    expect(page).to have_text("Menu item was successfully created.")
    expect(page).to have_text("Pasta")
    expect(page).to have_text("$8.0")  # Regular price
  end

  # ... Similar tests for editing and deleting menu items ...
end
