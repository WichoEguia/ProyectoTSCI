namespace :db do

  desc 'Truncate all tables, except schema_migrations (customizable)'
  task :truncate, [ :tables ] => 'db:load_config' do |t, args|
    args.with_defaults(tables: 'schema_migrations')

    skipped = args[:tables].split(' ')
    config  = ActiveRecord::Base.configurations[::Rails.env]

    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.tables.each do |table|
      next if table == 'schema_migrations'

      case ActiveRecord::Base.connection.adapter_name.downcase.to_sym
        when :mysql2 || :postgresql
          ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
        when :sqlite
          ActiveRecord::Base.connection.execute("DELETE FROM #{table}")
      end
    end
  end

end
