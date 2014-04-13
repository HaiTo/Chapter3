require 'spec_helper'

#認証に対するテスト
describe "Authentication" do
  subject {page}
  describe "signin page" do
    # コンテンツのテスト
    before{visit signin_path}
    it{ should have_content('Sign in')}
    it{ should have_title('Sign in')}
  end

  # signin機能自体のテスト
  describe "signin" do
    before{visit signin_path}
    # 入力情報が謝っている場合のテスト
    describe "with invalid information" do
      before{click_button "Sign in"}
      it{should have_title("Sign in")}
      it{should have_selector('div.alert.alert-error',text:'Invalid')}

      # 再訪問後の正しい表示検証
      describe "after visiting another page" do
        before{ click_link "Home"}
        it {should_not have_selector('div.alert.alert-error')}
      end
    end

    # 入力情報が正しい場合に表示されるPageのテスト
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",with: user.email.upcase
        fill_in "Password",with: user.password
        click_button "Sign in"
      end
      ## 表示のテスト
      it {should have_title(user.name)}
      it {should have_link('Profile',href: user_path(user))}
      it {should have_link('Sign out',href: signout_path)}
      it {should_not have_link('Sign in',href: signin_path)}

      # サインアウト機能のテスト
      describe "followed by signout" do
        before {click_link "Sign out"}
        it { should have_link("Sign in")}
      end
    end
  end
end