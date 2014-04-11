class AddPasswordDigestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :password_digest, :string
    # add_column(:〜に対して,〜の属性を,~の型で追加) うわださいこの日本語
  end
end
