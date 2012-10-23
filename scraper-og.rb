require 'nokogiri'   
require 'open-uri'  

doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/List_of_programmers/"))

doc.xpath('div.mw-content-text a').each do | node |  
    puts node.text  
end  



# programmer_site = "http://en.wikipedia.org/wiki/List_of_programmers/"

# index_doc = Nokogiri::HTML(open(programmer_site))
# people_links = (index_doc/"div.mw-content-text a")

# people_links.each do |person_link|

#   person_href = programmer_site + person_link.attr("href")
#   person_doc = Nokogiri::HTML(open(person_href))
#   name = (person_doc/"h1").inner_text