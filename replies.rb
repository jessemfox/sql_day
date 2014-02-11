require_relative 'questionsdatabase'
require_relative 'users'
require_relative 'questions'

class Replies
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def self.find_by_id(id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    self.new(data_hash[0])
  end

  def self.find_by_question_id(id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        question_id = ?
    SQL
    data_hash.map { |row| Replies.new(row) }
  end

  def self.find_by_user_id(id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    data_hash.map { |row| Replies.new(row) }
  end

  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @parent_reply_id = options["parent_reply_id"]
    @user_id = options["user_id"]
    @body = options["body"]
  end

  def author
    i = self.user_id
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, i)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    data_hash.map { |row| Users.new(row) }
  end

  def question
    q = self.question_id
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, q)
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?
    SQL
    data_hash.map { |row| Questions.new(row) }
  end

  def parent_reply
    p = self.parent_reply_id
    raise "no parent reply to reference" if p.nil?
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, p)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    Replies.new(data_hash[0])
  end

  def child_replies
    i = self.id
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, i)
    SELECT
      *
    FROM
      replies
    WHERE
      parent_reply_id = ?
    SQL
    data_hash.map { |row| Replies.new(row) }
  end

end
