require_relative 'questionsdatabase'
require_relative 'questions'
require_relative 'users'

class QuestionFollowers
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_followers
      WHERE
        id = ?
    SQL
    self.new(data_hash)
  end

  def self.followers_for_question_id(id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      u.id, u.fname, u.lname
    FROM question_followers qf
    JOIN questions q ON q.id = qf.question_id
    JOIN users u ON u.id = qf.user_id
    WHERE q.id = ?
    SQL
    data_hash.map { |row| Users.new(row) }
  end

  def self.followed_questions_for_user_id(id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      q.*
    FROM question_followers qf
    JOIN questions q ON q.id = qf.question_id
    JOIN users u ON u.id = qf.user_id
    WHERE u.id = ?
    SQL
    data_hash.map { |row| Questions.new(row) }
  end

  def self.most_followed_questions(n)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
     q.*, COUNT(*)
    FROM question_followers qf
    JOIN questions q ON q.id = qf.question_id
    JOIN users u ON u.id = qf.user_id
    GROUP BY qf.question_id
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