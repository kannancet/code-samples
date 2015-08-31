class CreateParsingLogs < ActiveRecord::Migration
  def change
    create_table :parsing_logs do |t|
      t.integer :total_rows_parsed
      t.integer :total_rows_suceeded
      t.integer :total_rows_failed

      t.timestamps null: false
    end
    add_attachment :parsing_logs, :operation_file
  end
end
