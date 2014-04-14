require 'spec_helper'

describe "User Pages" do
  subject { page }

  # indexPageに関するTest
  describe "index" do
    before do #User自動生成
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user,name:"Bob",email:"bob@example.com")
      FactoryGirl.create(:user,name:"Alice",email:"Alice@example.com")
      visit users_path
    end
    it { should have_title('All users') }
    it { should have_content('All users') }

    it "should list each user" do
      User.all.each do |user|
        expect(page).to have_selector('li',text: user.name)
      end
    end
  end

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
      # error文のテスト
      describe "afeter submission" do
        before{click_button submit}
        it{ should have_title('Sign up')}
        it{should have_content('error')}
      end
    end

    #正しく検証された時のテスト
    describe "after valid information" do
      ## 仮データの挿入
      before { 
        fill_in "Name", with: "Example User"
        fill_in "Email",  with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation",  with: "foobar"
      }
      # ユーザーの作成、また、Countの増加の検証
      it "should create a user" do
        expect{ click_button submit}.to change(User,:count).by(1)
      end

      # ユーザーがサインアップを終えたあと、サインインしたことを検証するテスト
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email:"user@example.com") }
        it {should have_link('Sign out')}
        it {should have_title(user.name)}
        it {should have_selector('div.alert.alert-success',text:'Wellcome')}
      end
    end
  end

  # ユーザー情報変更(edit)に対する検証
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) } 
    before {
      sign_in user
      visit edit_user_path(user)
    }

    #edit pageに対する検証
    describe "page" do
      it {should have_title("Edit user")}
      it {should have_content("Update your profile")}
      it {should have_link("change",href: 'http://gravatar.com/emails')}
    end

    # 入力された情報が正しく検証されなかった場合のテスト
    describe "with invalid information" do
      before {click_button "Save changes"}
      it {should have_content('error')}
    end

    # 入力された情報が正しく検証された場合のテスト
    describe "with valid information" do
      let(:new_name) { "New Name" }
      let(:new_email) { "new@example.com" }

      before do #情報の入力
        fill_in "Name", with: new_name
        fill_in "Email",  with: new_email
        fill_in "Password",with: user.password
        fill_in "Confirm Password", with:user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out',href: signout_path) }
      specify {expect(user.reload.name).to eq new_name}
      specify {expect(user.reload.email).to eq new_email}
    end
  end
end