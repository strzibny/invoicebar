module Features
  module SessionHelpers
    def sign_in(login:, password:)
      visit '/login'
      fill_in t('attributes.user.email'), with: login
      fill_in t('attributes.user.password'), with: password
      click_button t('buttons.login')
    end
  end
end
