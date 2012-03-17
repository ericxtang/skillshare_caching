require 'digest/md5'
require 'ap'

class GettoHashTable
  attr_reader :buckets

  def initialize
    @buckets = Array.new(10)
  end

  def put(key, value)
    generic_put(@buckets, key, value)
  end

  def get(key)
    return (val = get_tuple(@buckets, key))? val[1] : nil
  end

  def rehash!(size)
    new_buckets = Array.new(size)
    @buckets.each do |bucket|
      if bucket
        bucket.each do |key_val|
          generic_put(new_buckets, key_val[0], key_val[1])
        end
      end
    end
    @buckets = new_buckets
  end

  def get_tuple(buckets, key)
    index = get_index(key, @buckets.size)
    if buckets[index]
      buckets[index].each do |tuple|
        if tuple[0] == key
          return tuple
        end
      end
      nil
    else 
      nil
    end
  end

  def generic_put(buckets, key, value)
    if tuple =get_tuple(buckets, key)
      tuple[1] = value
    else
      index = get_index(key, buckets.size)
      if buckets[index]
        buckets[index].insert(-1, [key, value])
      else
        buckets[index] = [[key, value]]
      end
    end
  end

  def get_hash(key)
    #key.bytes.inject{|a, b| a + b}
    Digest::MD5.hexdigest(key).hex
  end

  def get_index(key, size)
    (get_hash(key) % size) - 1
  end
end

total = (0..10).collect do |i|
  ht = GettoHashTable.new
  20.times do 
    o =  [('a'..'z'),('A'..'Z')].map{|i| i.to_a}.flatten;
    key =  (0..rand(5..10)).map{ o[rand(o.length)]  }.join;
    value =  (0..rand(5..10)).map{ o[rand(o.length)]  }.join;
    ht.put(key, value)
    #ap ht.buckets
  end

  ht.rehash!(50)
  ht.buckets.collect {|b| 1 if b && b.size > 1}.compact.size
end.inject{|a, b| a + b}

puts total
