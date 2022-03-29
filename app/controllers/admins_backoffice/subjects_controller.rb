class AdminsBackoffice::SubjectsController < AdminsBackofficeController
  before_action :set_subject, only: [:edit, :update, :destroy]
  
  def index
    respond_to do |format|
      format.html { @subjects = Subject.all.order(:description).page(params[:page]) }
      format.pdf { @subjects = Subject.all.order(:description) }
      format.json { @subjects = Subject.all.order(:description) }
    end
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(subject_params)
    if @subject.save
      redirect_to admins_backoffice_subjects_path, notice: "Assunto/Área criado!" 
    else
      render :new, notice: "Não foi possível criar um novo assunto/área!" 
    end
  end


  def edit
  end

  def update
    if @subject.update(subject_params)
      redirect_to admins_backoffice_subjects_path, notice: "Informações atualizadas!" 
    else
      render :edit, notice: "Não foi possível atualizar sua informações!" 
    end
  end

  def destroy
    if @subject.destroy
      redirect_to admins_backoffice_subjects_path, notice: "Assunto/Área removido!" 
    else
      render :index, notice: "Não foi possível remover o assunto/área!"
    end
  end

  private

  def set_subject
    @subject = Subject.find(params[:id])
  end
  
  def subject_params
    params.require(:subject).permit(:description)
  end

end
