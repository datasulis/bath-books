require 'rubygems'
require 'dotenv'
require 'hpricot'
require 'open-uri'
require 'csv'
require 'fileutils'

dir = File.dirname(__FILE__)
FileUtils.mkdir_p( File.join(dir, "..", "data") )

URL = "https://www.librarything.com/place/Bath%2C+Somerset%2C+England%2C+UK"

page = Hpricot( open(URL) )

books = page.search(".worksinseries tr")[1..-1]



CSV.open( File.join(dir, "..", "data", "set-in-bath.csv"), "w") do |csv|
  csv << [ "id", "uri", "title", "isbn", "author" ]

  books.each do |row|
    book_link = row.search("a")[0]
    author_link = row.search("a")[1]
    
    id = book_link["href"].split("/").last
    uri = "https://www.librarything.com#{book_link["href"]}"
    title = book_link.inner_text
    
    author = author_link.inner_text if author_link
    
    work_page = Hpricot( open(uri) )
    isbn = work_page.search("/html/head/meta[ @property='books:isbn']").attr("content")
    isbn = nil if isbn == "9781111111111"
    
    csv << [id, uri, title, isbn, author]
  end

end

