require 'sequel'

db_path = ENV['APP_ENV'] == 'test' ? ':memory:' : File.expand_path('../db/salary.db', __dir__)

DB = Sequel.connect("sqlite://#{db_path}")

DB.create_table?(:employees) do
  primary_key :id
  String :full_name, null: false
  String :job_title, null: false
  String :country, null: false
  Float :salary, null: false
end
