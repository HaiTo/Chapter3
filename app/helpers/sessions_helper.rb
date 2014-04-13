module SessionsHelper
  # Sign-inメソッド。
  # Tokenをブラウザのクッキーに投げて、ソレ以降そのクッキーを参照して、
  #   ログイン状態の維持を行う
  def sign_in user
    remember_token = User.new_remember_token #Tokenを生成
    cookies.permanent[:remember_token] = remember_token #クッキーにトークンを登録
    user.update_attribute(:remember_token,User.encrypt(remember_token)) #引数のuserに暗号化されたトークンを登録
    self.current_user = user #現在のユーザーは引数のuserに
  end

  # session状態を返す
  def signed_in?
    !current_user.nil? # 現在のユーザーが存在するなら、trueを返す  
  end

  # 現在のユーザーを返す
  def current_user=(user)
    @current_user = user
  end
  def current_user 
    # クッキーからトークンを取り出し、HASH化する
    remember_token = User.encrypt(cookies[:remember_token])
    # @current_userにトークンのユーザーを検索し、セッションを確立させる
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  ## サインアウトメソッド
  def sign_out
    self.current_user = nil #現在のユーザーを破棄
    cookies.delete(:remember_token) #クッキーを破棄
  end
end
