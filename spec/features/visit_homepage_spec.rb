require "rails_helper"

feature "Looking up the weather" do
  scenario "User enters a location" do
    VCR.use_cassette("user_looks_up_weather", record: :none) do
      visit root_path
      fill_in "location", :with => "San Jose"
      click_button "Go"

      expect(page).to have_text("Go San Jose is 64.24° F and condtions are scattered clouds")
    end
  end

  scenario "User does not enter a location" do
    visit root_path
    fill_in "location", :with => ""
    click_button "Go"

    expect(page).to have_text("Please enter a location.")
  end
end