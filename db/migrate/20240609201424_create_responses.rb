class CreateResponses < ActiveRecord::Migration[7.1]
  def change
    create_table :responses do |t|
      t.string :content
      t.references :applicant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
