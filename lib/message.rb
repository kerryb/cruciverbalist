class Message
  include MongoMapper::Document

  after_create do
    FIREHOSE_PRODUCER.publish(to_json).to("/chat")
  end
end
