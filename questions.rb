require_relative 'questionsdatabase'
require_relative 'users'
require_relative 'replies'
require_relative 'question_followers'

class Questions
  attr_accessor :id, :title, :body, :user_id

  def self.find_by_id(id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    self.new(data_hash[0])
  end

  def self.find_by_author_id(author_id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        questions
      WHERE
        user_id = ?
    SQL
    data_hash.map { |row| Questions.new(row) }
  end

  def self.most_followed(n)
    QuestionFollowers.most_followed_questions(n)
  end

  def initialize(options = {})
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end

  def author
    author = self.user_id
    data_arr = QuestionsDatabase.instance.execute(<<-SQL, author)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL
    Users.new(data_arr[0])
  end

  def replies
    Replies.find_by_question_id(self.id)
  end

  def followers
    QuestionFollowers.followers_for_question_id(self.id)
  end

  def likers
    QuestionLikes.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLikes.num_likes_for_question_id(self.id)
  end

end