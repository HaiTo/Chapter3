require 'spec_helper'

describe "Microposts" do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @microposts = user.microposts.build(content:"Loerm ipsum")
  end

  subject { @microposts }

  # 所有するメソッド、フィールドの検証
  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user){ should eq user } #:userが let(:user)と一致するかどうか

  # 検証
  it { should be_valid }

  # MicroPostがユーザーに紐付けられていること
  describe "when user_id is not persent" do
    before { @microposts.user_id = nil }
    it { should_not be_valid }
  end
  
  # MicroPostがブランクである場合
  describe "with blank content" do
    before { @microposts.content = "" }
    it { should_not be_valid }
  end

  # Micropostが長すぎる場合
  describe "with content that is too long" do
    before { @microposts.content = "a"*141}
    it { should_not be_valid }
  end

  # In_Reply_Toに対するテスト郡
  describe "with have in_reply_to" do
    let(:user) { FactoryGirl.create(:user) }
    let(:reply_user) { FactoryGirl.create(:user,name:"ReplyMan") }
    let(:micropost) { FactoryGirl.create(:micropost,user:user,content:"@ReplyMan hoge") }
    before do
    end
    #it {p micropost}
    #it {p reply_user }
    describe "should not have in_reply_to" do
      before { micropost.in_reply_to = reply_user.name}
      it "should not have in_reply_to" do
        expect(micropost.in_reply_to).not_to eq "Example User"
      end
      it "should have in_reply_to to ReplyMan" do
        expect(micropost.in_reply_to).to eq reply_user.name
      end
    end
  end
end