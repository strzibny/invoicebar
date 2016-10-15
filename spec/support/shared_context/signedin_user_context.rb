RSpec.shared_context 'Signed-in user' do
  before do
    user = create(:invoice_bar_user,
      email: 'testuser@google.com',
      password: '123456781'
    )
    sign_in login: 'testuser@google.com', password: '123456781'
  end

  after do
    click_link 'Odhlásit se'
  end
end
