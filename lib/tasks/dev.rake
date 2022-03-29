namespace :dev do

  DEFAULT_PASSWORD = 123456
  DEFAULT_FILES_PATH = File.join(Rails.root, 'lib', 'tmp')

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Apagando BD...') { %x(rails db:drop)}
      show_spinner('Criando BD...') { %x(rails db:create)}
      show_spinner('Migrando BD...') { %x(rails db:migrate)}
      show_spinner('Cadastrando o administrador...') { %x(rails dev:add_default_admin)}
      show_spinner('Cadastrando administradores adicionais...') { %x(rails dev:add_extra_admins)}
      show_spinner('Cadastrando o usuario...') { %x(rails dev:add_default_user)}
      show_spinner('Cadastrando assuntos...') { %x(rails dev:add_subjects)}
      show_spinner('Cadastrando perguntas e respostas...') { %x(rails dev:add_questions_and_answers)}
    else
      puts 'Voce nao esta em ambiente de desenvolvimento'
    end
  end
  
  desc "Adiciona o administrador padrao"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona administradores adicionais"
  task add_extra_admins: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end

  desc "Adiciona o usuario padrao"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adiciona assuntos"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILES_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona perguntas e respostas"
  task add_questions_and_answers: :environment do
    Subject.all.each do |subject|
      rand(3..5).times do |i|
        params = create_questions_params(subject)
        array_answers = params[:question][:answers_attributes]

        add_answers(array_answers)
        elect_true_answer(array_answers)
   
        Question.create!(params[:question])
      end
    end
  end

  desc "Reseta o contador dos assuntos"
  task reset_subject_counter: :environment do
    show_spinner('Resetando contador dos assuntos...') do
      Subject.find_each do |subject|
        Subject.reset_counters(subject.id, :questions)
      end
    end
  end

  desc "Adiciona todas as respostas no Redis"
  task add_answers_to_redis: :environment do
    show_spinner('Adicionando todas as respostas no Redis...') do
      Answer.find_each do |answer|
        Rails.cache.write(answer.id, "#{answer.question_id}@@#{answer.correct}")
      end
    end
  end

  private

  def show_spinner(msg_start, msg_end = "Concluido!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end

  def create_questions_params(subject = Subject.all.sample)
    {question: {
          description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
          subject: subject,
          answers_attributes: []
      }
    }
  end

  def create_answer_params(correct = false)
    {description: Faker::Lorem.sentence, correct: correct }
  end

  def add_answers(array_answers = [])
    rand(3..4).times do |j|
      array_answers.push(create_answer_params)
    end
  end
  
  def elect_true_answer(array_answers = [])
    selectec_index = rand(array_answers.size)
    array_answers[selectec_index] = create_answer_params(true)
  end

end
