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
      #it{should have_selector('div.alert.alert-error',text:'Invalid')}
      it {should have_error_message('Invalid')}

      # 再訪問後の正しい表示検証
      describe "after visiting another page" do
        before{ click_link "Home"}
        it {should_not have_selector('div.alert.alert-error')}
      end
    end

    # 入力情報が正しい場合に表示されるPageのテスト
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      #before do
      #  fill_in "Email",with: user.email.upcase
      #  fill_in "Password",with: user.password
      #  click_button "Sign in"
      #end
      before{ valid_signin(user)}
      ## 表示のテスト
      it {should have_title(user.name)}
      it {should have_link('Profile',href: user_path(user))}
      it {should have_link('Sign out',href: signout_path)}
      it {should_not have_link('Sign in',href: signin_path)}
      it {should have_link('Settings',href:edit_user_path(user))}
      it { should have_link('Users',href: users_path) }

      # サインアウト機能のテスト
      describe "followed by signout" do
        before {click_link "Sign out"}
        it { should have_link("Sign in")}
      end

    end
  end

  # authorizationが必要な機能、全てのテスト
  describe "authorization" do
    ## サインイン済みユーザーの挙動
    describe "for mon-singed-in user" do
      let(:user) { FactoryGirl.create(:user) }
      describe "when attempting to visit a protected page" do
        before {
          visit edit_user_path(user)
          sign_in user
        }
        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title('Edit user')
          end
          # 再度サインインしても適切な表示がされるかのテスト
          describe "when signing in agein" do
            before do
              delete signout_path
              visit signin_path
              sign_in user
            end
            it "should rener the default (profile) page" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

      describe "visiting the edit page" do
        before {visit edit_user_path(user)}
        it { should have_title('Sign in') }
      end
      
      describe "submitting to the update action" do
        before { patch user_path(user)}
        specify{expect(response).to redirect_to(signin_path)}
      end

      # ユーザーのコントローラーに関するテスト
      describe "in the User controller" do
        describe "visiting the user controller" do
          describe "visiting the user index" do
            before {visit users_path}
            it { should have_title('Sign in') }
          end
        end
        ## フォローユーザー一覧ページのテスト
        describe "visiting the following page" do
          #フォロー中ユーザー一覧ページに移動して
          before{ visit following_user_path(user)} 
          # タイトルにSign in を含んでいるか？
          it { should have_title("Sign in") }
        end
        ## 被フォローユーザー一覧ページのテスト
        describe "visiting the followers page" do
          before {visit followers_user_path(user)}
          it { should have_title("Sign in") }
        end
      end

      # マイクロソフトの制御テスト
      describe "in the Microposts controller" do
        # マイクロポストの生成
        describe "submitting to the create action" do 
          before {post microposts_path}
          specify{expect(response).to redirect_to(signin_path)}
        end
      end

      # Relationships コントローラーに対するテスト
      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path}
          specify{expect(response).to redirect_to(signin_path)}
        end
        describe "submitting to the destroy action" do
          before {delete relationship_path(1)}
          specify {expect(response).to redirect_to(signin_path)}
        end
      end
    end
    # 正しいユーザーであることを要求するテスト
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user,email:"wrong@example.com") }
      before {sign_in user,no_capybara: true}
      describe "submitting a GET request to the User#edit action" do
        before{ get edit_user_path(wrong_user)}
        specify{expect(response.body).not_to match(full_title('Edit user'))}
        specify{expect(response).to redirect_to(root_url)}
      end
      describe "submitting a PATCH request to the Users#update action" do
        before { patch user_path(wrong_user)}
        specify{ expect(response).to redirect_to(root_path)}
      end
    end

    #削除をAdmin以外から保護するテスト
    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }
      before {sign_in non_admin, no_capybara: true}
      describe "submitting ad DELETE request to the User#destroy action" do
        before {delete user_path(user)}
        specify { expect(response).to redirect_to(root_path)}
      end
    end
  end
end