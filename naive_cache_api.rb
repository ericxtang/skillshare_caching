require 'sinatra'
require 'mongo'

$cache = {}
$cache_ordering = []
$conn = Mongo::Connection.new()

get '/:name' do
  value = find_cache(params[:name])
  "result: #{value.inspect}\n"
end

def find_cache(name)
  unless val = $cache[name]
    val = $conn["skillshare"]["names"].find({"name" => name}).to_a
    if $cache_ordering.size == 10
      key = $cache_ordering.delete_at(0)
      $cache.delete(key)
    else
      $cache_ordering.insert(-1, name)
    end
    $cache[name] = val
  end
  val
end
