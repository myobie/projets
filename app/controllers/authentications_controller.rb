class AuthenticationsController < ApplicationController
  respond_to :html
  skip_before_filter :require_authentication

  def create
    old_token = AccessToken.find_by_token_header(params[:token])
    @user = old_token.user
    new_token = AccessToken.generate(@user)
    old_token.destroy
    cookies.permanent.signed[:access_token] = new_token.token_header
    redirect_to root_path
  end
end
