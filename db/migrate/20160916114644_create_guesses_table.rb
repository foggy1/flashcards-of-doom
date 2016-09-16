class CreateGuessesTable < ActiveRecord::Migration
  def change
    create_table :guesses do |t|
      t.string :response, null: false
      t.references :card
      t.references :round

      t.timestamps(null: false)
    end
  end
end
