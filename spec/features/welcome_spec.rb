require 'rails_helper'

RSpec.describe 'Welcome', type: :system do
  it 'index' do
    visit '/welcome/index'
    expect(page).to have_selector(:link_or_button, "Administrar")
    expect(page).to have_selector(:link_or_button, "Reservar")
  end
end

RSpec.describe 'Create-Movie', type: :system do
  it 'new-movie' do
    # Fill form
    visit '/movies/new'
    fill_in "movie_name", :with => "test-movie-name"
    fill_in "movie_image", :with => "https://i.redd.it/nvaxpuqwius41.jpg"
    fill_in "movie_planners_attributes_0_start_date", :with => "12/01/2021"
    fill_in "movie_planners_attributes_0_end_date", :with => "12/10/2021"
    select "Room 6", from: "movie_planners_attributes_0_room"
    select "Noche", from: "movie_planners_attributes_0_time"
    click_link "Agregar otra Sala/Horario"
    click_button "Agregar"

    # Check movie
    expect(page).to have_content("test-movie-name")
    expect(page).to have_content("2021-12-01")
    expect(page).to have_content("2021-12-10")
    expect(page).to have_content("6") # Room 6
    expect(page).to have_content("3") # Noche
    expect(page).to have_content("1") # Room 1
  end

  after do
    DatabaseCleaner.clean
  end
end
