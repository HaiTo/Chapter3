class UsersController < ApplicationController
  before_action :signed_in_user,only: [:edit,:update,:index]
  before_action :correct_user, only: [:edit,:update]
  
  def index
    @users = User.all
  end
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
      sign_in @user #その場ですぐSign-in
      flash[:success] = "Wellcome to the Sample App!"
      redirect_to @user
  	else
  		# 保存に失敗した場合
  		render 'new' 
  	end
  end

  # Edit
  def edit
    @user = User.find_by(params[:id])
  end

  def update
    @user = User.find_by(params[:id])
    if @user.update_attributes(user_params)
      ## Updateに成功した場合
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      ## Updateに失敗した場合
      render 'edit'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name,:email,:password,:password_confirmation)
    end

    # Before actions
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url,notice: "Please sign in"
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
