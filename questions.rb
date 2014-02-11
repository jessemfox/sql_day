require_relative 'questionsdatabase'

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