class User < ActiveRecord::Base
	#　検証：　validates
	# Emailを小文字にして一意性の保証を行う
	before_save{ self.email = email.downcase}

	validates :name, presence: true, length: {maximum: 50}
	## 検証用メールアドレスの正しい(簡易的な)正規表現
	VALIED_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true , 
		format: {with: VALIED_EMAIL_REGEX},
		uniqueness: {case_sensitive: false}
	validates :password,length:{minimum: 6}
	has_secure_password
end
