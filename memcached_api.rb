require 'sinatra'
require 'dalli'
require 'mongo'

$dc = Dalli::Client.new('localhost:11211')
$conn = Mongo::Connection.new()

get '/:name' do
  value = find_cache(params[:name])
  "result: #{value.inspect}\n"
end

def find_cache(name)
  unless val = $dc.get(name)
    val = $conn["skillshare"]["names"].find({"name" => name}).to_a
    $dc.set(name, val)
  end
  val
end

#module Mongo
#  class Collection
#    def find(query)
#      unless val = $dc.get(query)
#        $dc.set(cursor, cursor.to_a)
#      end
#    end
#  end
#end
