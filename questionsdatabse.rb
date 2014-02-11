require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database

  include Singleton

  def initialize
    super("questions.db")
    self.results_as_hash = true
  end

end

class Users
  attr_accessor :id, :fname, :lname

  def self.find_by_id(id)
    query = <<- SQL
      SELECT
        *
      FROM
        users
      WHERE
        id = ?;
    SQL
    data_hash = QuestionsDB.instance.execute(query, id)
  end

  def self.find_by_name(fname, lname)
    query = <<- SQL
      SELECT
        *
      FROM
        users
      WHERE
        fname = ? AND
        lname = ?;
    SQL
    data_hash = QuestionsDB.instance.execute(query, fname, lname)
  end


  def initialize(options = {})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end
end

class Questions
  attr_accessor :id, :title, :body, :user_id

  def self.find_by_id(id)
    query = <<- SQL
      SELECT
        *
      FROM
        questions
      WHERE
        id = ?;
    SQL
    data_hash = QuestionsDB.instance.execute(query, id)
  end

  def initialize(options = {})
    @id = options["id"]
    @title = options["title"]
    @body = options["body"]
    @user_id = options["user_id"]
  end
end

class QuestionFollowers
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    query = <<- SQL
      SELECT
        *
      FROM
        question_followers
      WHERE
        id = ?;
    SQL
    data_hash = QuestionsDB.instance.execute(query, id)
  end

  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end
end

class Replies
  attr_accessor :id, :question_id, :parent_reply_id, :user_id, :body

  def self.find_by_id(id)
    query = <<- SQL
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?;
    SQL
    data_hash = QuestionsDB.instance.execute(query, id)
  end

  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @parent_reply_id = options["parent_reply_id"]
    @user_id = options["user_id"]
    @body = options["body"]
  end
end

class QuestionLikes
  attr_accessor :id, :question_id, :user_id

  def self.find_by_id(id)
    query = <<- SQL
      SELECT
        *
      FROM
        question_likes
      WHERE
        id = ?;
    SQL
    data_hash = QuestionsDB.instance.execute(query, id)
  end

  def initialize(options = {})
    @id = options["id"]
    @question_id = options["question_id"]
    @user_id = options["user_id"]
  end
end