class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    # set first id to a big value to prevent brute force with plain text attack
    create_table :urls do |t|
      t.string :url
      t.timestamps
    end
  end
end
