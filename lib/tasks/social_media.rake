namespace :social_media do
  desc "Testing"
  task update: :environment do
    User.update_social_media
  end
end
