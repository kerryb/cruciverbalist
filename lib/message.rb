class Message
  include MongoMapper::EmbeddedDocument

  key :username, String
  key :content, String
  key :type, String
  timestamps!

  def self.build username, content
    if content.start_with? "/me "
      new username: username, content: content.sub("/me ", ""), type: "action"
    else
      new username: username, content: content, type: "message"
    end
  end
end
