class Cell
  include MongoMapper::EmbeddedDocument

  key :username, String
  key :content, String

  belongs_to :conversation

  def self.build username, cell_id, content
    new username: username, cell_id: cell_id, content: content.downcase
  end
end
