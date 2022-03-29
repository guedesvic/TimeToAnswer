class UsersBackoffice::ZipCodeController < UsersBackofficeController
  
  def show
    @cep = ZipCode.new(params[:zip_code])
  end
end
