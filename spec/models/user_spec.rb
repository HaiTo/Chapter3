require 'spec_helper'

describe User do
  # beforeで@userを生成して、
  before(:each) do
    @user = User.new(name: "Example User",email: "user@example.com")
  end
  # subject で以下の処理は全て@userに対してのテストとなる
  subject { @user }

  it{ should respond_to(:name)}
  it{ should respond_to(:email)}

end