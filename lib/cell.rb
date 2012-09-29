class Cell
  include MongoMapper::EmbeddedDocument

  key :username, String
  key :content, String
  timestamps!

  def self.build username, cell_id, content
    new username: username, cell_id: cell_id, content: content.downcase
  end
end
