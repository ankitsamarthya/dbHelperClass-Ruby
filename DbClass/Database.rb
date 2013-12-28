require "rubygems"
require "mysql"
require "json"

class Database
	def initialize
		@con = Mysql.connect('localhost', 'root', 'secretpassword', 'ruby')
	end
	def insert(jsonstr)
		parsed = JSON.parse(jsonstr)
		if parsed.count == 1
			parsed["records"].each do |record|
				name = record['name']
				rank = Integer(record['rank'])
  				@con.query("INSERT INTO student(name,rank) VALUES('#{name}',#{rank})")
			end
		elsif parsed.count > 1
				name = parsed['name']
				rank = Integer(parsed['rank'])
  				@con.query("INSERT INTO student(name,rank) VALUES('#{name}',#{rank})")
  		else
  			puts "Nothing Passed"
		end
	end
	def fetch(num, where="")
		if num.instance_of?(String) && num=="all" && !where
			rs = @con.query('select * from student')
			rs.each_hash { |h| puts h['name'] + " " + h['rank']}
		elsif num.instance_of?(Fixnum)
			#puts num
			rs = @con.query("select * from student where id=#{num}")
			rs.each_hash { |h| puts h['name'] + " " + h['rank']}
		elsif num.instance_of?(Range)
			arr = [*num]
			i = arr.length - 1
			str = (arr[i]).to_s
			i=i-1;
			while i>=0
				str += ",#{arr[i]}"
				i = i-1
			end 
			rs = @con.query("select * from student where id IN (#{str})")
			rs.each_hash { |h| puts h['name'] + " " + h['rank']}
		else
			rs = @con.query("select * from student #{where}")
			rs.each_hash { |h| puts h['name'] + " " + h['rank']}
		end
	end
	def update(newjson)
		parsed = JSON.parse(newjson)
		if parsed.count == 1
			parsed["records"].each do |record|
				id = Integer(record['id'])
				name = record['name']
				rank = Integer(record['rank'])
  				@con.query("UPDATE student SET name = '#{name}', rank= #{rank} WHERE id = #{id}")
			end
		elsif parsed.count > 1
				id = Integer(parsed['id'])
				name = parsed['name']
				rank = Integer(parsed['rank'])
  				@con.query("UPDATE student SET name = '#{name}', rank= #{rank} WHERE id = #{id}")
  		else
  			puts "Nothing Passed"
		end
	end
	def delete(num, where="")
		if num.instance_of?(String) && num=="all" && !where
			rs = @con.query('DELETE * FROM student')
		elsif num.instance_of?(Fixnum)
			rs = @con.query("delete from student where id=#{num}")
		elsif num.instance_of?(Range)
			arr = [*num]
			i = arr.length - 1
			str = (arr[i]).to_s
			i=i-1;
			while i>=0
				str += ",#{arr[i]}"
				i = i-1
			end 
			rs = @con.query("delete from student where id IN (#{str})")
		else
			rs = @con.query("delete from student #{where}")
		end
	end
end


# db = Database.new

#  
# Insert Example
# 
# db.insert('{
# "records": [
# { "name":"John" , "rank":"2" }, 
# { "name":"Anna" , "rank":"1" }, 
# { "name":"Peter" , "rank":"5" }
# ]
# }')
#
# db.insert('{ "name":"Ankit" , "rank":"1" }')
#

#
# Fetch Example
# 
# db.fetch("all")
# db.fetch(3)
# db.fetch(1..5)
# db.fetch("all","where id=3")
#

#  
# Update Example
# 
# db.update('{
# "records": [
# { "id": "3", "name":"John" , "rank":"2" }, 
# { "id": "1", "name":"Ankit" , "rank":"9" }
# ]
# }')
#
# db.update('{ "id":"4" "name":"Ankit" , "rank":"1" }')
#

#
# Delete Example
# 
# db.delete("all")
# db.delete(3)
# db.delete(1..5)
# db.delete("all","where id=3")
#