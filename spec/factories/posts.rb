FactoryBot.define do
  factory :post do
    # db/seeds/post.rbをもとに入力した
    body { Faker::Hacker.say_something_smart }
    # spec/fixturesにテスト用の画像を配置する
    images { [File.open("#{Rails.root}/spec/fixtures/profile-placeholder.png")] }
    user
  end
end
