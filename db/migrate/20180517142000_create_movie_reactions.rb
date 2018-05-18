class CreateMovieReactions < ActiveRecord::Migration[5.1]
  def change
    create_table :movie_reactions do |t|
      t.integer :movie_id
      t.integer :user_id
      t.boolean :liked

      t.timestamps
    end
    add_index :movie_reactions, [:movie_id, :user_id], unique: true
  end
end
