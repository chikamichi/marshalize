ActiveRecord::Schema.define(:version => 0) do
  create_table :birds, :force => true do |t|
    t.string :name
    t.text   :locations
    t.text   :songs
    t.text   :friends
    #t.timestamps
  end
end
