require 'spec_helper'

feature 'User signs in and out' do
  scenario 'with valid email and password' do
    user = create(:invoice_bar_user,
      email: 'user@google.com',
      password: '123456781'
    )
    sign_in login: 'user@google.com', password: '123456781'
    click_link t('buttons.logout')
    expect(page).to have_content(t('messages.not_authenticated'))
  end

  scenario 'with invalid email or password' do
    user = create(:invoice_bar_user,
      email: 'user@google.com',
      password: '123456781'
    )
    sign_in login: 'user@google.com', password: '187654321'
    expect(page).to have_content(t('messages.not_authenticated'))
  end
end
