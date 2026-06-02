puts "🚀 超高速大量シードデータの生成を開始します... (目標: ユーザー1万人および現実的なランキング)"

ActiveRecord::Base.connection.execute("TRUNCATE users, quizzes, quiz_items, tags, words RESTART IDENTITY CASCADE")

hashed_password = BCrypt::Password.create('password')
quiz_status_value = defined?(Quiz) && Quiz.respond_to?(:statuses) ? Quiz.statuses[:completed] : 'completed'

users_data = []
10000.times do |i|
  users_data << {
    name: "ランカーブルー_#{i + 1}",
    email: "user#{i + 1}@example.com",
    password_digest: hashed_password,
    created_at: Time.current,
    updated_at: Time.current
  }
end

puts "👉 ユーザー1万人のデータをDBに注入中..."
inserted_users = User.insert_all!(users_data)
user_ids = inserted_users.map { |u| u['id'] }

puts "👉 単語データを生成中..."
word_key = Word.column_names.include?('name') ? :name : :word

japanese_raw_words = [
  { word: "解決", meaning: "問題や困ったことをうまく処理して終わらせること。" },
  { word: "開発", meaning: "新しい技術や製品、仕組みなどを新しく作ること。" },
  { word: "確認", meaning: "間違いがないかどうか、目で見て確かめること。" },
  { word: "準備", meaning: "物事を始める前に、必要なものを用意しておくこと。" },
  { word: "挑戦", meaning: "難しいことや新しいことに、勇気を持ってやってみること。" },
  { word: "継続", meaning: "前からやっていることを、休まずに長く続けること。" },
  { word: "集中", meaning: "一つのことだけに自分の力や意識を集めること。" },
  { word: "経験", meaning: "実際に自分でやってみて、知識や役立つ力を得ること。" },
  { word: "成長", meaning: "体が大きくなったり、能力が進歩して立派になること。" },
  { word: "成果", meaning: "あることを頑張った結果、得られた良い出来栄えのこと。" },
  { word: "理解", meaning: "物事の意味や内容、相手の気持ちを正しくわかること。" },
  { word: "表現", meaning: "自分の気持ちや考えを、言葉や絵などで外に表すこと。" },
  { word: "想像", meaning: "目に見えないことや未来のことを、頭の中で思い浮かべること。" },
  { word: "変化", meaning: "状態や形、性質などが前とは違うものに変わること。" },
  { word: "満足", meaning: "自分の思い通りになって、十分幸せで不満がないこと。" },
  { word: "丁寧", meaning: "細かいところまで心がこもっていて、礼儀正しい様子。" },
  { word: "積極的", meaning: "自分から進んで進歩的に行動する様子。" },
  { word: "豊富", meaning: "種類や量がたくさんあって、豊かにそろっていること。" },
  { word: "感謝", meaning: "ありがたい、嬉しいと思う気持ちを相手に表すこと。" },
  { word: "応援", meaning: "頑張っている人を、力を貸したり声をかけたりして助けること。" }
]

words_data = japanese_raw_words.map do |data|
  {
    word_key => data[:word],
    meaning: data[:meaning],
    user_id: user_ids.first,
    created_at: Time.current,
    updated_at: Time.current
  }
end

Word.insert_all!(words_data)
word_ids = Word.pluck(:id)

puts "👉 ユーザー別のダミー学習データ(Quiz)を生成中..."
quizzes_data = []
user_skills = {}

active_user_ids = user_ids.sample(7000)

active_user_ids.each do |u_id|
  quizzes_data << {
    user_id: u_id,
    status: quiz_status_value,
    created_at: Time.current,
    updated_at: Time.current
  }
  user_skills[u_id] = rand(30..98)
end

inserted_quizzes = Quiz.insert_all!(quizzes_data)

puts "👉 設問別の正解/不正解(QuizItem)データをマッピング中..."
quiz_items_data = []

inserted_quizzes.each do |q|
  u_id = q['user_id']
  skill = user_skills[u_id] || 60
  question_count = rand(10..40)

  question_count.times do
    is_correct = rand(100) < skill

    quiz_items_data << {
      quiz_id: q['id'],
      word_id: word_ids.sample,
      is_correct: is_correct,
      created_at: Time.current,
      updated_at: Time.current
    }
  end
end

puts "👉 数十万件の設問データを最終注入中..."
quiz_items_data.each_slice(50000) do |slice|
  QuizItem.insert_all!(slice)
end

puts "🎉 すべてのシードデータの構築が完了しました！"
puts "----------------------------------------"
puts "- 生成された総会員数: #{User.count}人"
puts "- 登録された総単語数: #{Word.count}個"
puts "- 完了したクイズ数  : #{Quiz.count}個"
puts "- 解答された総設問数: #{QuizItem.count}個"
puts "----------------------------------------"
