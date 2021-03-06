require 'spec_helper'

describe User do
  # beforeで@userを生成して、
  before(:each) do
    @user = User.new(name: "Example User",email: "user@example.com",
        password: "foobar", password_confirmation: "foobar")
  end
  # subject で以下の処理は全て@userに対してのテストとなる
  subject { @user }
  ## そもそも @userが各Method(Field)を持っているか？
  it{ should respond_to(:name)}
  it{ should respond_to(:email)}
  it { should respond_to(:password_digest)}
  it{should respond_to(:password)}
  ## confirmation -> 二回入力する奴
  it{should respond_to(:password_confirmation)}
  it{should respond_to(:remember_token)}
  it{should respond_to(:authenticate)}
  it{should respond_to(:admin)}
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }

  ### valid(検証)済みかどうかのチェック
  ## name に対する'検証'のテスト
  # @user.valid? -> be_valid という検証用Methodが生成されている
  it {should be_valid }
  describe "when name is not present" do
    before{ @user.name = " "}
    it { should_not be_valid }
  end

  ## email に対する'検証'テスト
  describe "when email is not present" do
    before{ @user.email = " "}
    it {should_not be_valid }
  end

  ## nameの長さに対するテスト
  describe "when name is too long" do
    before{ @user.name = "a" * 51}
    it {should_not be_valid }
  end

  ### emailの正当性に対する(簡易)テスト
  # invalid(未検証)な場合失敗するテスト
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end
  # valid(検証済み)な場合成功するテスト
  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org first.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end   
    end
  end

  # アドレスが一意かどうかのテスト
  describe "when email address is already taken" do
    before do
      ## Userを一つ取得して
      user_with_same_email = @user.dup
      ## 大文字に変換
      user_with_same_email.email = @user.email.upcase
      ## saveしてみる
      user_with_same_email.save
    end
    ## 検証
    it {should_not be_valid }
  end
  # アドレスが大文字小文字混じりの場合，小文字に変換しても検証が成功するかのテスト
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foor@ExAmple.CoM" }
    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
    
  end

  #### Passwordに対するテスト
  # Passwordが空欄の時のテスト
  describe "when password it not present" do
    before do
      @user = User.new(name: "Example User",email:'hoge@example.com',
        password:" ",password_confirmation: " ")
    end
    it {should_not be_valid}
  end
  # passwordとconfirmationが一致してない場合のテスト
  describe "when password doesnt match confirmation" do
    before{ @user.password_confirmation = "mismatch"}
    it {should_not be_valid}
  end
  
  # パスワードの長さテスト
  describe "with a password thats too short" do
    before{ @user.password = @user.password_confirmation = "a"*5 }
    it {should be_invalid}
  end
  # パスワードの検証に対するテスト
  describe "return balue of authenticate method" do
    before {@user.save}
    ## emailでUserを検索するMethodを定義
    let(:found_user) { User.find_by(email: @user.email) }
    # パスワードが一致するテスト
    describe "with valid password" do
      it{should eq found_user.authenticate(@user.password)}
    end
    # パスワードが一致しないテスト
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      it {should_not eq user_for_invalid_password }
      specify {expect(user_for_invalid_password).to be_false}
    end
  end

  #秘密トークンに対する検証
  describe "remember token" do
    before {@user.save}
    its(:remember_token){should_not be_blank}
  end

  # 管理者権限に対するテスト
  it {should_not be_admin}
  describe "with admin attribute set to 'ture'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end
    it { should be_admin }
  end

  # マイクロポストについての検証
  describe "micropost associations" do
    before {@user.save} 
    let!(:older_micropost) do 
      FactoryGirl.create(:micropost,user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost,user: @user, created_at: 1.hour.ago)
    end
    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost,older_micropost]
    end

    # Userが破棄された場合、そのユーザーの所有するPostも破棄されることのテスト
    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a
      @user.destroy
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    # あるUserが破棄された場合、そのユーザーのRelationShipの削除をテストする
    it "should destroy accosiated relationships" do
      relationships = @user.relationships
      @user.destroy
      relationships.each do |relationship|
        expect(Relationship.where(followed_id: user.id)).to be_empty
      end
    end
    ## status feed に対するTest
    describe "status" do
      let(:unfollowed_post)do
        FactoryGirl.create(:micropost,user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }
      its(:feed){should include(newer_micropost)}
      its(:feed){should include(older_micropost)}
      its(:feed){should_not include(unfollowed_post)}
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  ## followingに対するテスト
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users){should include(other_user)}

    ## フォローに対するテスト
    describe "following" do
      subject {other_user}
      its(:followers){should include(@user)}
    end

    ## アンフォローに対するテスト
    describe "and unfollowing" do
      before { @user.unfollow!(other_user)}
      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user)}
    end
  end
end



















