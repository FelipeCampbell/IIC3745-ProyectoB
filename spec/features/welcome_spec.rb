require 'rails_helper'

RSpec.describe 'Welcome', type: :system do
  it 'index' do
    visit '/welcome/index'
    expect(page).to have_content("Welcome#index")
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
    select "Room 3", from: "movie_planners_attributes_0_room"
    select "Noche", from: "movie_planners_attributes_0_time"
    click_link "Add Another Room/Time"
    click_button "Create"
  end

  after do
    DatabaseCleaner.clean
  end
end
