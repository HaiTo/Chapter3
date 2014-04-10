require 'spec_helper'

describe "Static Pages" do
  describe "Home page" do
    it "should have the content 'Sample App'" do
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
    it "should have the Title 'Home'" do
      visit '/static_pages/home'
      expect(page).to have_title('Ruby on Rails Tutorial Sample App')
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
    it "should have the Title 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_title('Ruby on Rails Tutorial Sample App | Help')
    end
  end

  describe "About page" do
    it "should have the content 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end
    it "should have the Title 'About Us'" do
      visit '/static_pages/about'
      expect(page).to have_title('Ruby on Rails Tutorial Sample App | About Us')
    end
  end

  describe "Contact Page" do
    it "should have the content 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end
    it "should have the title 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_title('Ruby on Rails Tutorial Sample App | Contact')
    end
  end
end