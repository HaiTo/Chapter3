class RelationshipsController < ApplicationController
  before_action :signed_in_user
  respond_to :html,:js
  
  def create
    # User/params[relathionship]/params[followerd_id]
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_with @user
    #respond_to do |format|
    #  format.html {redirect_to @user}
    #  format.js
    #end
  end

  def destroy
    # Createの逆参照
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_with @user
    #respond_to do |format|
    #  format.html {redirect_to @user}
    #  format.js
    #end
  end
end