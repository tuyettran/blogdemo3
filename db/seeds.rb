User.create full_name: "Tuyet Tran",
  email: "tuyet.tran.k59@gmail.com",
  password: "121212",
  role: 1

20.times do |index|
  User.create full_name: Faker::Name.name,
    email: "example-#{index+1}@railstutorial.org",
    gender: Random.rand(0..2),
    password: "123456"
end

users = User.order(:created_at).take 6

10.times do
  content = Faker::Lorem.paragraph paragraph_count = 10, supplemental = false
  title = Faker::Lorem.sentence
  users.each{|user| user.posts.create! title: title, content: content}
end

20.times do |index|
  Comment.create content: Faker::Lorem.sentence,
    post_id: Random.rand(1..10),
    user_id: Random.rand(1..10)
end

10.times do |index|
  Tag.create name: Faker::Lorem.word
end

10.times do |index|
  PostTag.create post_id: Random.rand(1..10),
    tag_id: Random.rand(1..10)
end

10.times do |index|
  Relationship.create follower_id: Random.rand(1..20),
    followed_id: Random.rand(1..10)
end
