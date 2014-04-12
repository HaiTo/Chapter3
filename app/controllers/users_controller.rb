class UsersController < ApplicationController
	def show
		# URLのパラメータが自動的にparamsに入ってくる
		@user = User.find(params[:id])
	end
  def new
    @user = User.new
  end
  # Createアクション
  def create
  	@user = User.new(user_params)
  	if @user.save # 返り値はtrue | false
  		# 保存が成功した場合 
      flash[:success] = "Wellcome to the Sample App!"
      redirect_to @user
  	else
  		# 保存に失敗した場合
  		render 'new' 
  	end
  end
  private
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end
end
