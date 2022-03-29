class UsersBackofficeController < ApplicationController
  before_action :authenticate_user!
  before_action :profile_build
  layout 'users_backoffice'
  
  private

  def profile_build
    current_user.build_user_profile if current_user.user_profile.blank?
  end
end
