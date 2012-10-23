require 'nokogiri'
require 'open-uri'
require 'sqlite3'
require 'FileUtils'

FileUtils.rm("programmers.db") if File.exists?("programmers.db")

db = SQLite3::Database.new "programmers.db"

db.execute <<-SQL
  CREATE TABLE programmers (
    id INTEGER PRIMARY KEY,
    name TEXT,
    tag_line TEXT,
    sidebox_info TEXT,
    wiki_url TEXT
  );
SQL

programmers_url = "http://en.wikipedia.org/wiki/List_of_programmers"
doc = Nokogiri::HTML(open(programmers_url))
programmers = (doc/"#mw-content-text li")
programmers.each do |programmer_link|
	next if !programmer_link.first_element_child
	next if !programmer_link.first_element_child.key?("href")
	wiki_url = "http://en.wikipedia.org" + programmer_link.first_element_child['href']
	tag_line = programmer_link.inner_text.split(' - ')[1]

	doc = Nokogiri::HTML(open(wiki_url))
	name = (doc/"#firstHeading span").inner_text
	sidebox_info = (doc/".vcard").inner_text
  # image_url = (doc/"img[src*=upload] a")
	db.execute("INSERT INTO programmers (name, tag_line, sidebox_info, wiki_url) 
     	      VALUES (?, ?, ?, ?)", name, tag_line, sidebox_info, wiki_url)
end
