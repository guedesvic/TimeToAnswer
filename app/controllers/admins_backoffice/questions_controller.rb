class AdminsBackoffice::QuestionsController < AdminsBackofficeController
  before_action :set_question, only: [:edit, :update, :destroy]
  before_action :get_subjects, only: [:new, :edit]
  
  def index
    @questions = Question.includes(:subject).order(:description).page(params[:page])
  end

  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to admins_backoffice_questions_path, notice: "Pergunta criado!" 
    else
      render :new, notice: "Não foi possível criar uma nova pergunta!" 
    end
  end


  def edit
  end

  def update
    if @question.update(question_params)
      redirect_to admins_backoffice_questions_path, notice: "Informações atualizadas!" 
    else
      render :edit, notice: "Não foi possível atualizar suas informações!" 
    end
  end

  def destroy
    if @question.destroy
      redirect_to admins_backoffice_questions_path, notice: "Pergunta removida!" 
    else
      render :index, notice: "Não foi possível remover a pergunta!"
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end
  
  def question_params
    params.require(:question).permit(:description, :subject_id, answers_attributes: [:id, :description, :correct, :_destroy])
  end

  def get_subjects
    @subjects = Subject.all
  end

end