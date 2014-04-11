class UsersController < ApplicationController
	def show
		# URLのパラメータが自動的にparamsに入ってくる
		@user = User.find(params[:id])
	end
  def new
  end
end
