require "migrake"
require "sequel"

class Migrake::SQLStore
  # Public: Connect to the database.
  #
  # db - Any valid argument to `Sequel.connect`.
  def initialize(db)
    @db = db.is_a?(Sequel::Database) ? db : Sequel.connect(db)
  end

  # Public: Make sure the table in which we will store tasks exists. Create it
  # if it doesn't.
  def prepare
    @db.create_table?(:migrake_tasks) do
      column :task, String, primary_key: true
    end
  end

  # Public: Insert a task into the store.
  #
  # task - A string with a task's name.
  #
  # Returns nothing.
  def put(task)
    @db[:migrake_tasks].insert(task: task)
  end

  # Public: Load all the tasks from the store.
  #
  # Returns a Set.
  def all
    Set.new(@db[:migrake_tasks].map { |row| row[:task] })
  end

  # Public: Write a whole set of tasks to the database, replacing what is in it.
  #
  # set - A Set of tasks.
  #
  # Returns nothing.
  def write(set)
    @db.transaction do
      @db[:migrake_tasks].truncate
      @db[:migrake_tasks].insert_multiple(set.to_a) { |task| { task: task } }
    end
  end
end

# Automagic configuration. If this environment has a DATABASE_URL (e.g. heroku),
# use Migrake::SQLStore and connect to that database. This requires the
# appropriate database adapter installed.
if ENV.key?("DATABASE_URL")
  Migrake.store = Migrake::SQLStore.new(ENV.fetch("DATABASE_URL"))
end
