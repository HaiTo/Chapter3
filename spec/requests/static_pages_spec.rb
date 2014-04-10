require 'spec_helper'

describe "Static Pages" do

  subject{page} #全てpageに対する操作なので,事前宣言

  describe "Home page" do
    before{ visit root_path} #事前フィルター
    it { should have_content('Sample App')}
    it {should have_title(full_title(''))}
    it {should_not have_title('| Home')}
  end

  describe "Help page" do
    before{ visit help_path}
    it {should have_content('Help')}
    it {should have_title(full_title('Help'))}
  end

  describe "About page" do
    before{ visit about_path}
    it {should have_content('About')}
    it {should have_title('About Us')}
  end

  describe "Contact Page" do
    before{ visit contact_path}
    it {should have_content('Contact')}
    it {should have_title('Contact')}
  end
end