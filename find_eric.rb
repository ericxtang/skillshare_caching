require 'httparty'

t = Time.now.to_f
result = HTTParty.get("http://localhost:6081/eric").body
#result = HTTParty.get("http://localhost:4567/eric").body
puts result.inspect
puts "Time: #{Time.now.to_f - t}"
