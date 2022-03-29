module SiteHelper
  
  def msg_jumbotron
    case params[:action]
    when 'index'
      "Ultimas perguntas cadastradas..."
    when 'questions'
      "Resultados encontrados para o termo \"#{sanitize params[:term]}\"..."
    when 'subject'
      "Questoes filtradas pelo assunto \"#{sanitize params[:subject]}\"..."
    end
  end
end
