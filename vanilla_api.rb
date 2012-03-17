require 'sinatra'
require 'mongo'

$conn = Mongo::Connection.new()

get '/:name' do
  value = find_value(params[:name])
  "result: #{value.inspect}\n"
end

def find_value(name)
  val = $conn["skillshare"]["names"].find({"name" => name}).to_a
  val
end
