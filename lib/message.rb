class Message
  include MongoMapper::Document

  key :username, String
  key :content, String

  belongs_to :conversation
end
