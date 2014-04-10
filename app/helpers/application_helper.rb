module ApplicationHelper
	#ページ毎の完全なタイトルを返す
	def full_title page_title
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			return base_title
		else
			return "#{base_title} | #{page_title}"
		end
	end
end
