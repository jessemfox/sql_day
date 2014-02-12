require_relative 'questionsdatabase'
require_relative 'users'

class QuestionLikes
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?
    SQL
    self.new(data_hash)
  end

  def self.likers_for_question_id(question_id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT u.*
    FROM question_likes ql
    JOIN questions q ON q.id = ql.question_id
    JOIN users u ON u.id = ql.user_id
    WHERE q.id = ?
    SQL
    data_hash.map { |row| Users.new(row) }
  end

  def self.num_likes_for_question_id(question_id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT COUNT (*)
    FROM question_likes ql
    JOIN questions q ON q.id = ql.question_id
    JOIN users u ON u.id = ql.user_id
    WHERE q.id = ?

    SQL
    data_hash[0].values.first
  end

  def self.liked_questions_for_user_id(user_id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT q.*
    FROM question_likes ql
    JOIN questions q ON q.id = ql.question_id
    JOIN users u ON u.id = ql.user_id
    WHERE q.user_id = ?

    SQL
    data_hash.map { |row| Questions.new(row) }
  end


  def self.most_liked_questions(n)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
     q.*
    FROM question_likes ql
    JOIN questions q ON q.id = ql.question_id
    JOIN users u ON u.id = ql.user_id
    GROUP BY ql.question_id
    ORDER BY COUNT(*) DESC LIMIT ?
    SQL
    data_hash.map { |row| Questions.new(row) }
  end


  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end
end