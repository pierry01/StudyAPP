class CreateMovies < ActiveRecord::Migration[5.2]
  def change
    create_table :movies do |t|
      t.string :name
      t.text :description
      t.date :release

      t.timestamps
    end
  end
end
