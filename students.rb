require 'sinatra'
require 'sqlite3'
require 'erb'

class Student
	@@attributes = %w{id 
										first_name
										last_name
										picture
										bio
										tagline
										email
										blog
										linkedin
										twitter
										github
										codeschool
										coderwall
										stackoverflow
										treehouse
										feed_1
										feed_2
										short_tagline
										short_bio
										fav_app_title1
										fav_app_title2
										fav_app_title3
										fav_app_desc1
										fav_app_desc2
										fav_app_desc3
									}

	@@attributes.each do |a|
		attr_accessor a.to_sym
	end

	attr_accessor	:students

	@@db = SQLite3::Database.new ("studentinfo.sqlite")

	def self.find_student(id)
		s = Student.new
		data = s.query_db("WHERE id =",id).flatten

		@@attributes.each_with_index do |a,i|
			# call that attribute= method on the students and set the value
			s.send("#{a}=", data[i])
		end	

		return s
	end

	def self.find_name(name)
		s = Student.new
		name_query = @@db.execute("SELECT id, first_name, last_name FROM students")
		
		name_query.each do |person|
			@match, first, last = person
			break if name.downcase == (first.downcase + last.downcase)
		end

		@person = find_student(@match)
	end

	def query_db(param,match)
		@@db.execute("SELECT * FROM students #{param}#{match}")
	end

	def return_students # i dont like this method as an instance method
		@students = query_db("","")
	end

end

#sinatra routes

	get '/:name' do |name|
		@person = Student.find_name(name)
		erb :page
	end

	get '/find_student/:id' do |id|
		@person = Student.find_student(id)
		erb :page
	end

	get '/' do
		@person = Student.new
		@person.return_students
		erb :index
	end	

Sinatra::Application.run!
