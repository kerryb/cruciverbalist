class Conversation
  include MongoMapper::Document

  key :crossword, String

  many :messages

  def self.for_crossword crossword
    first_or_create crossword: crossword
  end

  def create_message username, content
    messages.create username: username, content: content
  end
end
