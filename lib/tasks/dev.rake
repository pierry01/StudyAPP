require 'faker'

namespace :dev do
  DEFAULT_PASSWORD = 123123

  desc 'Configura o ambiente de desenvolvimento'
  task setup: :environment do
    if Rails.env.development?
      show_spinner('Apagando DB...') { %x(rails db:drop) }
      show_spinner('Criando DB...') { %x(rails db:create) }
      show_spinner('Migrando DB...') { %x(rails db:migrate) }

      show_spinner('Cadastrando o administrador padrão...') { %x(rails dev:add_default_admin) }
      show_spinner('Cadastrando usuário padrão...') { %x(rails dev:add_default_user) }

      show_spinner('Cadastrando filmes...') { %x(rails dev:generate_movies) }
      show_spinner('Adicionando imagens nos filmes...') { %x(rails dev:generate_images)}
    else
      puts 'Você não está em ambiente de desenvolvimento!'
    end
  end


  desc 'Adiciona o administrador padrão'
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end


  desc 'Adiciona o usuário padrão'
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end


  desc 'Cria movies'
  task generate_movies: :environment do
    20.times do
      Movie.create!( 
        name: Faker::Lorem.sentence,
        description: Faker::Lorem.paragraph,
        release: DateTime.now - Random.rand(90..500)
      )
    end
  end


  desc 'Add images to movies'
  task generate_images: :environment do
    Movie.all.each do |movie| 
      movie.image.attach(io: open(Faker::Placeholdit.image('800x500', 'jpeg', :random)), filename: 'some-image.jpg')
    end
  end


  private

  def show_spinner(msg_start, msg_end = 'Concluído!')
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
