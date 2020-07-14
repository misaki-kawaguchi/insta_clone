FactoryBot.define do
  factory :user do
    # db/seeds/user.rbをもとに作成した
    username { Faker::Internet.unique.username }
    email { Faker::Internet.unique.email }
    password { '0123456789' }
    password_confirmation { '0123456789' }
  end
end
