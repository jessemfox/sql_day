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

  def liked_question
    QuestionLikes.liked_questions_for_user_id(self.id)
  end

  def avg_karma
    i = self.id
    data_hash = QuestionsDatabase.instance.execute(<<-SQL, i)

    /* total # of likes */
    SELECT
      COUNT (*)
    FROM
      users u JOIN question_likes ql ON u.id = ql.user_id
      JOIN questions q ON q.id = ql.question_id
    WHERE
      q.user_id = ?


    /* total number of posts

    (SELECT
          COUNT(*)
        FROM
          questions
        WHERE
          user_id = ?)
    */

    SQL
  end

  def save
    params = [self.fname, self.lname]
    if self.id.nil?
      QuestionsDatabase.instance.execute(<<-SQL, *params)
      INSERT INTO
        users (fname, lname)
        VALUES
        (?, ?)
      SQL
      @id = QuestionsDatabase.instance.last_insert_row_id
    else
      i = self.id
      QuestionsDatabase.instance.execute(<<-SQL, *params, i)
      UPDATE
        users
      SET
        fname = ?,
        lname = ?
      WHERE
      id = ?
      SQL
    end
  end

end