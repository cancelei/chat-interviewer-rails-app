class CreateApplicants < ActiveRecord::Migration[7.1]
  def change
    create_table :applicants do |t|
      t.integer :years_of_experience
      t.string :favorite_programming_language
      t.boolean :willing_to_work_onsite
      t.boolean :willing_to_use_ruby
      t.string :interview_date

      t.timestamps
    end
  end
end
