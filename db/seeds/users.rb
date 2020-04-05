30.times do
  User.create!(
    # 使えるダミーデータはFakerのGitHub参照(Faker::Internet)
    # uniqueはデータが被らないように
    email: Faker::Internet.unique.email,
    username: Faker::Internet.unique.username,
    password: 'password',
    password_confirmation: 'password'
  )
end
