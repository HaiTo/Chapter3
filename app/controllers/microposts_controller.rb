class MicropostsController < ApplicationController
  before_action :signed_in_user,only: [:create,:destroy]
  before_action :correct_user,only: :destroy
  before_action :matching_reply,only: :create

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.in_reply_to = matching_reply#(micropost_params[:content])
    if @micropost.save #MicroPostの保存に成功した場合
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy  
    @micropost.destroy
    redirect_to root_url
  end

  private 
    def micropost_params
      params.require(:micropost).permit(:content)
    end
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end

    def matching_reply
      $& if (params[:content] =~ /(@\w*)/i) != ""
    end
end