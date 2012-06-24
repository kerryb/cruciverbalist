require "mongo_mapper"

MongoMapper.config = {"env" => {"uri" => ENV["MONGOHQ_URL"] || "mongodb://localhost/cruciverbalist"}}
MongoMapper.connect("env")
