module DeviseHelpers
  def sign_in(user)
    visit new_user_session_path
    within('form') do
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'ログイン'
      puts page.body 
    end
  end
end

  RSpec.configure do |config|
    config.include DeviseHelpers, type: :system
  end