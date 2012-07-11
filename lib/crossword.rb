class Crossword
  include MongoMapper::Document

  key :path, String

  many :messages
  many :cells

  def self.with_path path
    first_or_create path: path
  end

  def create_message username, content
    Message.build(username, content).tap do |message|
      messages << message
      save
    end
  end

  def create_cell username, cell_id, content
    Cell.build(username, cell_id, content).tap do |message|
      cells << message
      save
    end
  end
end
