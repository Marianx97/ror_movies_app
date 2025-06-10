class CreateMovies < ActiveRecord::Migration[7.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.text :description
      t.string :director
      t.string :producer
      t.date :release_date
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
