require_relative 'questionsdatabase'

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