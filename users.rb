require_relative 'questionsdatabase'

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
  send