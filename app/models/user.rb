class User < ActiveRecord::Base
	#　検証：　validates
	### :name に対する各走査
	validates :name, presence: true, length: {maximum: 50}

	### :email に対する各操作
	# Emailを小文字にして一意性の保証を行う
	#before_save{ self.email = email.downcase}
	before_save{ self.email.downcase!}
	## 検証用メールアドレスの正しい(簡易的な)正規表現
	VALIED_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true , 
		format: {with: VALIED_EMAIL_REGEX},
		uniqueness: {case_sensitive: false}

	### :passwordに対する各操作
	validates :password,length:{minimum: 6}
	has_secure_password

	### remomber tokenに対する操作
	# メソッド参照を行う
	before_create :create_remember_token
	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end
	# HASH化
	def User.encrypt token
		Digest::SHA1.hexdigest(token.to_s)
	end

	private
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
