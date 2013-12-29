require "rubygems"
require "mysql"
require "json"

class Database
	def initialize(tablename)
		@table_name = tablename
		@con = Mysql.connect('localhost', 'root', 'secretpassword', 'ruby')
	end
	def insert(hashstr)
		if hashstr.count != 0
			keystr = ""
			valstr = ""
			hashstr.each do |record|
				keystr = ""
				valstr = ""
				record.each do |k,v|
					keystr += "#{k},"
					valstr += "'#{v}',"
				end
				keystr = keystr.chop
				valstr = valstr.chop
  				@con.query("INSERT INTO #{@table_name}(#{keystr}) VALUES(#{valstr})")
			end
  		else
  			puts "Nothing Passed"
		end
	end
	def fetch(num, where="")
		if num.instance_of?(String) && num=="all"
			if !where
				rs = @con.query('select * from #{@table_name}')
				rs.each_hash { |h| puts h['name'] + " " + h['rank']}
			else
				rs = @con.query("select * from #{@table_name} #{where}")
				rs.each_hash { |h| puts h['name'] + " " + h['rank']}
			end				
		elsif num.instance_of?(Fixnum)
			if !where
				rs = @con.query("select * from #{@table_name} where id=#{num}")
				rs.each_hash { |h| puts h['name'] + " " + h['rank']}
			else
				rs = @con.query("select * from #{@table_name} #{where} AND id=#{num}")
				rs.each_hash { |h| puts h['name'] + " " + h['rank']}
			end
		elsif num.instance_of?(Range)
			arr = [*num]
			i = arr.length - 1
			str = (arr[i]).to_s
			i=i-1;
			while i>=0
				str += ",#{arr[i]}"
				i = i-1
			end
			if !where 
				rs = @con.query("select * from #{@table_name} where id IN (#{str})")
				rs.each_hash { |h| puts h['name'] + " " + h['rank']}
			else
				rs = @con.query("select * from #{@table_name} #{where} AND id IN (#{str})")
				rs.each_hash { |h| puts h['name'] + " " + h['rank']}
			end
		end
	end
	def update(newhash)
		if newhash.count != 0
			str = ""
			newhash.each do |record|
				str = ""
				record.each do |k,v|
					str += "#{k} = '#{v}',"
				end
				str = str.chop
				id = record[:id]
  				@con.query("UPDATE #{@table_name} SET #{str} WHERE id = #{id}")
			end
  		else
  			puts "Nothing Passed"
		end
	end
	def delete(num, where="")
		if num.instance_of?(String) && num=="all"
			if !where
				rs = @con.query('DELETE * FROM #{@table_name}')
			else
				rs = @con.query("delete from #{@table_name} #{where}")
			end
		elsif num.instance_of?(Fixnum)
			if !where
				rs = @con.query("delete from #{@table_name} where id=#{num}")
			else
				rs = @con.query("delete from #{@table_name} #{where} AND id=#{num}")
			end
		elsif num.instance_of?(Range)
			arr = [*num]
			i = arr.length - 1
			str = (arr[i]).to_s
			i=i-1;
			while i>=0
				str += ",#{arr[i]}"
				i = i-1
			end
			if !where 
				rs = @con.query("delete from #{@table_name} where id IN (#{str})")
			else
				rs = @con.query("delete from #{@table_name} #{where} AND id IN (#{str})")
			end
		end
	end
end


class Student < Database
end


stu = Student.new("student")

stu.insert([{:name=>"Ankit",:rank=>3},{:name=>"Mohit", :rank=>1}])
