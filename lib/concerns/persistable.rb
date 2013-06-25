module Persistable
  module ClassMethods

    def new_from_db(row)
      new.tap do |s|
        attributes.keys.each_with_index do |attribute, index|
          s.send("#{attribute}=",row[index])
        end
      end
    end

    def table_name
      "#{self.to_s.downcase}s"
    end

    def drop
      db.execute "DROP TABLE IF EXISTS #{table_name};"
    end

    def table_exists?(table_name)
      db.execute "SELECT * FROM sqlite_master WHERE type = 'table' AND name = ?", table_name
    end

    def create_table
      db.execute "CREATE TABLE IF NOT EXISTS #{table_name} (
        #{attributes_for_create}
      )"
    end

    def attributes_for_create
      self.attributes.collect{|k,v| [k,v].join(" ")}.join(", ")
    end

    def attributes_for_update
      self.attributes.keys.reject{|k| k == :id}.collect{|k| "#{k} = ?"}.join(", ")
    end

    def column_names_for_insert
      self.attributes.keys[1..-1].join(", ")
    end

  end


  module InstanceMethods

    def persisted?
      self.id
    end

    def save
      persisted? ? update : insert
    end

    def attributes
      self.class.attributes.keys.collect do |attribute|
        self.send(attribute)
      end
    end

    def attributes_for_sql
      self.attributes[1..-1]
    end

    def question_marks_for_sql
      ("?," * attributes_for_sql.size)[0..-2]
    end

    private

      def insert
        self.class.db.execute "INSERT INTO #{self.class.table_name} (#{self.class.column_names_for_insert}) VALUES (#{self.question_marks_for_sql})", self.attributes_for_sql
        self.id = self.class.db.last_insert_row_id
      end

      def update
        self.class.db.execute "UPDATE #{self.class.table_name} SET #{self.class.attributes_for_update} WHERE id = ?", [attributes_for_sql, self.id].flatten
      end

  end
end