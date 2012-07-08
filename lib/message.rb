class Message
  include MongoMapper::Document

  key :username, String
  key :content, String
  key :type, String

  belongs_to :conversation
end
