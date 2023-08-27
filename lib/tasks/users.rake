namespace :users do
  desc 'Create users'
  task create: :environment do
    Bot.create(email: 'android@mail.com', password: SecureRandom.base36 , nickname: 'Android')
  end
end