require 'spec_helper'

describe "User Pages" do
  subject { page }

  # profilePageに対するテスト
  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) }
  	before { visit user_path(user)}

  	it {should have_content(user.name)} #Page内にuser.nameが含まれている事
  	it {should have_title(user.name)} #Titleがuser.nameであること
    
  end

  # signup-pageに関するテスト
  describe "sign-up page" do
    before{ visit signup_path }

    it{should have_content('Sign up')}
    it{should have_title(full_title('Sign up'))}
  end

  # sign-up 自体に対するTest
  describe "signup" do
    before {visit signup_path}
    let(:submit) { "Create my account" }
    # 検証で正しくない時のテスト
    describe "with invalid information" do
      # Create my accountをおした時に正常に更新されなければ、Countを増やさないことの検証
      it "shouldnot create a user" do
        expect {click_button submit}.not_to change(User,:count)
      end
    end

    #正しく検証された時のテスト
    describe "description" do
      ## 仮データの挿入
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email",  with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation",  with: "foobar"
      end
      # ユーザーの作成、また、Countの増加の検証
      it "should create a user" do
        expect{ click_button sublime}.to change(User,:count).by(1)
      end
    end
  end
end