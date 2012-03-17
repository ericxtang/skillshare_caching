require 'mongo'

conn = Mongo::Connection.new()

500000.times do 
  o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;
  name =  (0..rand(5..10)).map{ o[rand(o.length)]  }.join;
  conn["skillshare"]["names"].insert({"name" => name})
end

conn["skillshare"]["names"].insert({"name" => "eric"})
