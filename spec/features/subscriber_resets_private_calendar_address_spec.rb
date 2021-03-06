require "rails_helper"

feature "subscriber resets private calendar address", type: :feature do
  scenario "and sees it change" do
    sign_in

    initial_token = create(:access_token, :personal, issuer: current_character)

    visit calendar_path
    click_button(id: "btn-reset-private-address")

    expect(page).not_to have_link(href: /#{initial_token.token}$/)
  end

  scenario "and can not see reset address" do
    sign_in

    initial_token = create(:access_token, :personal, issuer: current_character)

    visit calendar_path
    click_button(id: "btn-reset-private-address")
    visit calendar_feed_path(id: initial_token.token)

    expect(page).to have_text(/not found/i)
  end
end
