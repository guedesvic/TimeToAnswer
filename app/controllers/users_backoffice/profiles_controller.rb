class UsersBackoffice::ProfilesController < UsersBackofficeController
  before_action :set_user
  before_action :verify_password, only: [:update]

  def edit
    @user.build_user_profile if @user.user_profile.blank?
  end

  def update
    if @user.update(user_params)
      bypass_sign_in(@user)
      unless user_params[:user_profile_attributes][:avatar]
        redirect_to users_backoffice_profiles_path, notice: "Informações atualizadas!"
      end
    else
      render :edit, notice: "Não foi possível atualizar sua informações!" 
    end
  end


  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, user_profile_attributes: [:id, :address, :zip_code, :gender, :birthdate, :avatar])
  end

  def verify_password
    if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
      params[:user].extract!(:password, :password_confirmation)
    end
  end
end
