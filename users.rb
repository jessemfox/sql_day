require_relative 'questionsdatabase'
require_relative 'questions'
require_relative 'question_followers'

class Users
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        users
      WHERE
        id = ?
    SQL
    self.new(data_hash[0])
  end

  def self.find_by_name(fname, lname)
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND
        lname = ?
    SQL
    data_hash.map { |row| Users.new(row) }
  end

  def initialize(options = {})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def authored_questions
    Questions.find_by_author_id(self.id)
  end

  def authored_replies
    Replies.find_by_user_id(self.id)
  end

  def followed_questions
    QuestionFollowers.followed_questions_for_user_id(self.id)
  end

end