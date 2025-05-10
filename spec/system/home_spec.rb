require 'rails_helper'

RSpec.describe 'Home', type: :system do
  it 'トップページが表示される' do
    visit root_path
    expect(page).to have_content('Better Than Yesterday')
  end
end
