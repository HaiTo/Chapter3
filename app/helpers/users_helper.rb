module UsersHelper

  #与えられたユーザーのGravatarを帰す
  def gravatar_for user,options={size:50}
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "http://secure.gravatar.com/avatar/#{gravatar_id}?s=#{options[:size]}"
    image_tag(gravatar_url,alt: user.name,class: "gravatar")
  end
end
