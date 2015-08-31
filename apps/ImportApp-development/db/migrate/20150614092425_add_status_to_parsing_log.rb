class AddStatusToParsingLog < ActiveRecord::Migration
  def change
    add_column :parsing_logs, :status, :string, default: "parsing"
  end
end
