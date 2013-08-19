#!/usr/bin/env ruby

require 'pg'

def getTimeStamp
	Time.now.strftime('%Y-%m-%d %H:%M:%S')
end

filesArr = Dir["../data/us/yob[0-9][0-9][0-9][0-9].txt"].entries.sort
puts "found #{filesArr.size} files"

%w(F M).each do |sex|
	allYears = []
	filesArr.each do |f|
		year = f.scan(/yob(\d{4})/)	# YYYY
		thisYear = []
		rank = 1
		totalCount = 0
		File.new(f).each do |line|
			line.chomp!
			cols = line.split(',')
			if cols[1] == sex
				thisYear << [year[0][0], rank, cols[0], cols[2]]
				rank += 1
				totalCount += cols[2].to_i
			end
		end
		thisYear.each {|elem| elem << 100*elem[3].to_i/totalCount.to_f}
		allYears.concat(thisYear)
	end

	#outFile = File.new("#{sex.downcase}_combined.txt", 'w+')
	#allYears.each {|elem| outFile.puts elem.join(',') }
	#outFile.close

	dbConn = PG.connect(dbname: 'namez')
	table = (sex == 'M') ? 'boys' : 'girls'
	rows = 0
	allYears.each do |r|
		dbConn.exec('begin') if(rows % 100000 == 0)
		sql = "insert into #{table}(name, year, rank, count, pct)
			values(\'#{r[2]}\', #{r[0].to_i}, #{r[1]}, #{r[3]}, #{r[4]})"
		dbConn.exec(sql)
		rows += 1
		dbConn.exec('commit') if(rows % 100000 == 0)
	end
	dbConn.exec('commit')

end
