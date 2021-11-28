require 'rails_helper'

RSpec.describe 'Buy-One-Seat', type: :system do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  it 'buy-seat' do
    # Fill form
    visit '/movies/new'
    fill_in "movie_name", :with => "test-movie-name"
    fill_in "movie_image", :with => "https://i.redd.it/nvaxpuqwius41.jpg"
    fill_in "movie_planners_attributes_0_start_date", :with => "12/01/2021"
    fill_in "movie_planners_attributes_0_end_date", :with => "12/10/2021"
    click_button "Agregar"

    visit '/seats/movie_id=1&room=1&time=1'
    # Check movie
    expect(page).to have_content("TEST-MOVIE-NAME")
    expect(page).to have_content("1") # Room 6
    # find(:xpath, "//a[@href='seats/movie_id=23&room=5&time=2?col=12&row=A']").click
    click_button "Buscar asientos"
    find(:xpath, "/html/body/div[1]/div[2]/div/div[2]/div/div[1]/div[1]/a[1]/div").click
    click_button "Comprar"
    expect(find(:xpath, "/html/body/div[1]/div[2]/div/div[2]/div/div[2]/div[1]/div[2]").style("background-color")["background-color"]).to eq('rgba(255, 0, 0, 1)')
    expect(page).to have_content("Compra exitosa!")

  end

  after do
    DatabaseCleaner.clean
  end
end

RSpec.describe 'Buy-Multiple-Seats', type: :system do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  it 'buy-seat' do
    # Fill form
    visit '/movies/new'
    fill_in "movie_name", :with => "test-movie-name"
    fill_in "movie_image", :with => "https://i.redd.it/nvaxpuqwius41.jpg"
    fill_in "movie_planners_attributes_0_start_date", :with => "12/01/2021"
    fill_in "movie_planners_attributes_0_end_date", :with => "12/10/2021"
    click_button "Agregar"

    visit '/seats/movie_id=1&room=1&time=1'
    # Check movie
    expect(page).to have_content("TEST-MOVIE-NAME")
    expect(page).to have_content("1") # Room 6
    # find(:xpath, "//a[@href='seats/movie_id=23&room=5&time=2?col=12&row=A']").click
    click_button "Buscar asientos"
    
    find(:xpath, "/html/body/div[1]/div[2]/div/div[2]/div/div[1]/div[1]/a[1]/div").click
    find(:xpath, "/html/body/div[1]/div[2]/div/div[2]/div/div[1]/div[1]/a[2]/div").click

    click_button "Comprar"

    expect(find(:xpath, "/html/body/div[1]/div[2]/div/div[2]/div/div[2]/div[1]/div[2]").style("background-color")["background-color"]).to eq('rgba(255, 0, 0, 1)')
    expect(find(:xpath, "/html/body/div[1]/div[2]/div/div[2]/div/div[2]/div[1]/div[3]").style("background-color")["background-color"]).to eq('rgba(255, 0, 0, 1)')
    
    expect(page).to have_content("Compra exitosa!")
    
  end

  after do
    DatabaseCleaner.clean
  end
end

RSpec.describe 'Buy-Seats-On-Different-Rows-Fail', type: :system do
  before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.start
  end

  it 'buy-seat' do
    # Fill form
    visit '/movies/new'
    fill_in "movie_name", :with => "test-movie-name"
    fill_in "movie_image", :with => "https://i.redd.it/nvaxpuqwius41.jpg"
    fill_in "movie_planners_attributes_0_start_date", :with => "12/01/2021"
    fill_in "movie_planners_attributes_0_end_date", :with => "12/10/2021"
    click_button "Agregar"

    visit '/seats/movie_id=1&room=1&time=1'
    # Check movie
    expect(page).to have_content("TEST-MOVIE-NAME")
    expect(page).to have_content("1") # Room 6
    # find(:xpath, "//a[@href='seats/movie_id=23&room=5&time=2?col=12&row=A']").click
    click_button "Buscar asientos"
    
    find(:xpath, "/html/body/div[1]/div[2]/div/div[2]/div/div[1]/div[1]/a[1]/div").click

    find(:xpath, "/html/body/div[1]/div[2]/div/div[2]/div/div[1]/div[2]/a[1]/div").click

    
    expect(page).to have_content("Recuerda solo puedes comprar asientos de la misma fila!")
    
  end

  after do
    DatabaseCleaner.clean
  end
end

