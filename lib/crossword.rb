class Crossword
  include MongoMapper::Document

  key :path, String

  many :messages

  def self.with_path path
    first_or_create path: path
  end

  def create_message username, content
    if content.start_with? "/me "
      messages.create username: username, content: content.sub("/me ", ""), type: "action"
    else
      messages.create username: username, content: content, type: "message"
    end
  end
end
