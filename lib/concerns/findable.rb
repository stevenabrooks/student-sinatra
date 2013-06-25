module Findable
  module ClassMethods

    def all
      all_rows = db.execute "SELECT * FROM students;"
      all_rows.collect{|row| new_from_db(row)}
    end

    def find_by(*args)
      args.flatten.each do |arg|
        define_singleton_method("find_by_#{arg}") do |value|
          rows_found = db.execute "SELECT * FROM #{table_name} WHERE #{arg} = ?", value
          new_from_db(rows_found.first) if !rows_found.empty?
        end
      end
    end
    # find_by must be called by the class extending it to initialize all find_by_attribute methods

    def find(id)
      self.find_by_id(id)
    end

    def where(conditions)
      # conditions is a hash - get a string (to be used by SQL WHERE) based on that hash
      arg = conditions.to_a.collect{|condition| "#{condition[0].to_s} = :#{condition[0]}"}.join(" AND ")
      rows_found = db.execute("SELECT * FROM #{table_name} WHERE #{arg}", conditions)
      rows_found.collect{|row| new_from_db(row)} if !rows_found.empty?
    end

  end
end