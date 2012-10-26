require 'sinatra'
require 'sqlite3'
require 'erb'

class Programmer < Sinatra::Base
	@@attributes = %w{id 
						name
						tag_line
						sidebox_info
						image_url
						wiki_url
									}

	@@attributes.each do |a|
		attr_accessor a.to_sym
	end

	attr_accessor	:programmers

	@@db = SQLite3::Database.new ("programmers.db")

	def self.find_programmer(id)
		s = Programmer.new
		data = s.query_db("WHERE id =",id).flatten

		@@attributes.each_with_index do |a,i|
			# call that attribute= method on the students and set the value
			s.send("#{a}=", data[i])
		end	

		return s
	end

	def self.find_name(name)
		s = Programmer.new
		name_query = @@db.execute("SELECT id, name FROM programmers")
		
		name_query.each do |person|
			@match, first, last = person
			break if name.downcase == (first.downcase + last.downcase)
		end

		@person = find_student(@match)
	end

	def query_db(param,match)
		@@db.execute("SELECT * FROM programmers #{param}#{match}")
	end

	def return_programmers 
		@programmers = query_db("","")
	end

end

#sinatra routes

	# get '/:name' do |name|
	# 	@person = Student.find_name(name)
	# 	erb :page
	# end

	# get '/find_student/:id' do |id|
	# 	@person = Student.find_student(id)
	# 	erb :page
	# end

	get '/' do
		@person = Programmer.new
		@person.return_programmers
		erb :index
	end	

Sinatra::Programmer.run!
