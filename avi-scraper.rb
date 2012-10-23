require 'open-uri'
require 'nokogiri'
require 'sqlite3'
require 'debugger'
require 'FileUtils'
# Open a database
FileUtils.rm("students.db") if File.exists?("students.db")

# File.new("students.db", "+w")
db = SQLite3::Database.new "students.db"

# Create a database
rows = db.execute <<-SQL
  CREATE TABLE students (
    id INTEGER PRIMARY KEY,
    name TEXT,
    tag_line TEXT,
    bio TEXT,
    mail TEXT,
    blog TEXT,
    linkedin TEXT,
    twitter TEXT,
    github TEXT,
    codeschool TEXT,
    coderwall TEXT,
    stackoverflow TEXT,
    teamtreehouse TEXT
  );
SQL

student_site = "http://students.flatironschool.com/"

index_doc = Nokogiri::HTML(open(student_site))
people_links = (index_doc/"div.one_third a")

people_links.each do |person_link|
  person_href = student_site + person_link.attr("href")
  person_doc = Nokogiri::HTML(open(person_href))
  name = (person_doc/"h1").inner_text
  tag_line = (person_doc/"h2").inner_text

  person_image_src = (person_doc/"#navcontainer div").first

  bio = (person_doc/"div.two_third p").inner_text

  mail = (person_doc/"li.mail a").first
  mail = mail.attr("href") if mail

  blog = (person_doc/"li.blog a").first
  blog = blog.attr("href") if blog

  linkedin = (person_doc/"li.linkedin a").first
  linkedin = linkedin.attr("href") if linkedin

  twitter = (person_doc/"li.twitter a").first
  twitter = twitter.attr("href") if twitter

  # favorite_apps = {
  #   :first => {
  #     :name => (person_doc/"div.one_third h4").inner_text
  #     :text => (person_doc/"div.one_third p").inner_text
  #   }
  # }
  begin
    github = (person_doc/"a[href*='github']").first.attr("href")
    codeschool = (person_doc/"a[href*='codeschool']").first.attr("href")
    coderwall = (person_doc/"a[href*='coderwall']").first.attr("href")
    stackoverflow = (person_doc/"a[href*='stackoverflow']").first.attr("href")
    teamtreehouse = (person_doc/"a[href*='teamtreehouse']").first.attr("href")
  rescue => e
    puts "problem getting #{e} for #{name}"
  end

  insert = <<-SQL
    INSERT INTO students (name, tag_line,
                          bio, mail, blog,
                          linkedin, twitter,
                          github, coderwall,
                          codeschool, stackoverflow,
                          teamtreehouse)
          VALUES (
                    '#{name}', '#{tag_line}',
                          '#{bio}', '#{mail}', '#{blog}',
                          '#{linkedin}', '#{twitter}',
                          '#{github}', '#{coderwall}',
                          '#{codeschool}', '#{stackoverflow}',
                          '#{teamtreehouse}'
  );
  SQL

  db.execute insert
  raise insert.inspect
  rase
end