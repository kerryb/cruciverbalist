class Message
  include MongoMapper::Document

  key :username, String
  key :content, String
  key :action, Boolean

  belongs_to :conversation
end
