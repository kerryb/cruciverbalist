class Conversation
  include MongoMapper::Document

  key :crossword, String

  many :messages

  def self.for_crossword crossword
    first_or_create crossword: crossword
  end

  def create_message username, content
    if content.start_with? "/me "
      messages.create username: username, content: content.sub("/me ", ""), type: "action"
    else
      messages.create username: username, content: content, type: "message"
    end
  end
end
