module Features
  module SessionHelpers
    def sign_in(login:, password:, remember_me: false)
      visit '/login'
      fill_in 'E-mail', with: login
      fill_in 'Heslo', with: password
      click_button 'Přihlásit'
    end
  end
end
