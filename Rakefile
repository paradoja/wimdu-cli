require_relative 'lib/wimdu/app'

task default: :migrate

desc "Run migrations"
task :migrate do
  ActiveRecord::Migrator.migrate('db/migrate',
                                 ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
end
