require 'rails_helper'

RSpec.describe 'Welcome', type: :system do
    it 'index' do
        visit '/welcome/index'
        expect(page).to have_content("Welcome#index")
    end
end
