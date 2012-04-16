require_relative "test_helper"

describe Migrake::SQLStore do
  it "can read a stored set" do
    create_migrake_table!

    set = Set.new(["a", "b", "c"])
    save_in_source set

    store = Migrake::SQLStore.new(source)
    assert_equal set, store.all
  end

  it "an empty file means an empty set" do
    create_migrake_table!

    store = Migrake::SQLStore.new(source)
    assert_equal Set.new, store.all
  end

  it "can add an entry to the store" do
    create_migrake_table!

    store = Migrake::SQLStore.new(source)
    store.put("test")

    assert store.all.include?("test")
  end

  it "can write a set replacing whatever is there on the file" do
    create_migrake_table!

    save_in_source Set.new(["d", "e", "f", "g"])

    store = Migrake::SQLStore.new(source)
    store.write Set.new(["a", "b", "c"])

    assert_equal Set.new(["a", "b", "c"]), store.all
  end

  it "creates the migrake_tasks when you call #prepare" do
    store = Migrake::SQLStore.new(source)

    assert !source.table_exists?(:migrake_tasks)
    store.prepare
    assert source.table_exists?(:migrake_tasks)
  end

  before do
    source.drop_table?(:migrake_tasks)
  end

  def save_in_source(set)
    source[:migrake_tasks].insert_multiple(set) { |task| { task: task } }
  end

  def source
    @source ||= Sequel.sqlite
  end

  def create_migrake_table!(db = source)
    db.create_table?(:migrake_tasks) do
      column :task, String, primary_key: true
    end
  end
end
