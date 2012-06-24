require "mongo_mapper"

if ENV["MONGOHQ_HOST"]
  MongoMapper.connection = Mongo::Connection.new(ENV["MONGOHQ_HOST"], ENV["MONGOHQ_PORT"])
  MongoMapper.database = ENV["MONGOHQ_DATABASE"]
  MongoMapper.database.authenticate(ENV["MONGOHQ_USER"],ENV["MONGOHQ_PASSWORD"])
else
  MongoMapper.database = "cruciverbalist"
end
