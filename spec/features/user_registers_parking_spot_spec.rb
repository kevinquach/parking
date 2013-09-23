require 'spec_helper'

feature "user registers spot", %Q{
  As a parker
  I want to register my spot with my name
  So that the parking company can identify my car
} do

  # Acceptance Criteria:

  # * I must specify a first name, last name, email, and parking spot number
  # * I must enter a valid parking spot number (the lot has spots identified as numbers 1-60)
  # * I must enter a valid email

  scenario 'specifies valid information, registers spot' do
    prev_count = ParkingRegistration.count
    visit '/'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Spot number', with: 5
    click_button 'Register'
    expect(page).to have_content('You registered successfully')
    expect(ParkingRegistration.count).to eql(prev_count + 1)
  end

  scenario 'attempts to register spot that is taken' do
    FactoryGirl.create(:parking_registration,
      spot_number: 24,
      parked_on: Date.today)

    prev_count = ParkingRegistration.count

    visit '/'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Smith'
    fill_in 'Email', with: 'user@example.com'
    fill_in 'Spot Number', with: 24
    click_button 'Register'

    expect(page).to_not have_content('You registered successfully')
    expect(page).to have_content('is already taken')
    expect(ParkingRegistration.count).to eql(prev_count)
  end

end
