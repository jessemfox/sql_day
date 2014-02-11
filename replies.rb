require_relative 'questionsdatabase'

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
