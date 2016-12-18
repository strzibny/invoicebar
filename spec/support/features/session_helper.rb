module Features
  module SessionHelpers
    def sign_in(login:, password:)
      visit '/login'
      fill_in t('attributes.user.email'), with: login
      fill_in t('attributes.user.password'), with: password
      click_button t('buttons.login')
    end

    def sign_out
      click_link t('buttons.logout')
    end

    def register(login:,
                 password:,
                 name:,
                 tax_id:,
                 street:,
                 street_number:,
                 postcode:,
                 city:,
                 city_part:,
                 extra_address_line:)
      visit '/signup'
      # User details
      fill_in t('attributes.user.email'), with: login
      fill_in t('attributes.user.password'), with: password
      fill_in t('attributes.user.name'), with: name
      fill_in t('attributes.user.tax_id'), with: tax_id
      # Address
      fill_in t('attributes.address.street'), with: street
      fill_in t('attributes.address.street_number'), with: street_number
      fill_in t('attributes.address.postcode'), with: postcode
      fill_in t('attributes.address.city'), with: city
      fill_in t('attributes.address.city_part'), with: city_part
      fill_in t('attributes.address.extra_address_line'), with: extra_address_line
      click_button t('buttons.signup')
    end
  end
end
