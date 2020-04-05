User.limit(10).each do |user|
  post = user.posts.create(
    # Full Phrase
    body: Faker::Hacker.say_something_smart,
    # ランダムな画像を表示
    remote_images_urls: %w[https://picsum.photos/350/350/?random]
  )
end