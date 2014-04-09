# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.

require "securerandom"

def secure_token
  token_file = Rails.root.join('.secret')
  if File.exist?(token_file)
    File.read(token_file).chomp
  else
    #token_fileが存在しなければ生成する
    token = SecureRandom.hex(64)
    File.write(token_file,token)
    return token #明示的Return
  end
end

SampleApp::Application.config.secret_key_base = secure_token
#SampleApp::Application.config.secret_key_base = 'caf581c6b47fa853cf7b356ea30657584d104ea436bd75c87008fabf707534c402099a35b5904bcd3d0ab737421a3c66942838c13d0b44474361d8cf560b43e0'
