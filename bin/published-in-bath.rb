#
# <http://bnb.data.bl.uk/id/place/Bath> appears to be primary location for pub events
#
# Other spatial:
#   http://bnb.data.bl.uk/id/place/BathAvon (only single linked resource)
#   http://bnb.data.bl.uk/id/place/Bath%28England%29 (seems to be linked from dct:spatial)
#
# There are separate place concepts, e.g:
#
#  http://bnb.data.bl.uk/id/concept/place/lcsh/Bath%28England%29
# 

require 'rubygems'
require 'json'
require 'sparql/client'
require 'csv'
require 'fileutils'

dir = File.dirname(__FILE__)
FileUtils.mkdir_p( File.join(dir, "..", "data") )

QUERY=<<-EOL
PREFIX bibo: <http://purl.org/ontology/bibo/>
PREFIX bio: <http://purl.org/vocab/bio/0.1/>
PREFIX blt: <http://www.bl.uk/schemas/bibliographic/blterms#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX event: <http://purl.org/NET/c4dm/event.owl#> 
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX geo: <http://www.w3.org/2003/01/geo/wgs84_pos#>
PREFIX isbd: <http://iflastandards.info/ns/isbd/elements/>
PREFIX org: <http://www.w3.org/ns/org#>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
PREFIX rda: <http://RDVocab.info/ElementsGr2/>
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX void: <http://rdfs.org/ns/void#> 
PREFIX c4dm: <http://purl.org/NET/c4dm/event.owl#>

SELECT DISTINCT ?bnb ?book ?title ?isbn ?timeLabel ?creator ?name WHERE {
   
   ?publication event:place <http://bnb.data.bl.uk/id/place/Bath>;
      c4dm:time ?time.

   ?time rdfs:label ?timeLabel.

   ?book 
      a bibo:Book;
      blt:bnb ?bnb;
      blt:publication ?publication;
      bibo:isbn10 ?isbn;
      dct:title ?title;
      dct:creator ?creator.

   ?creator foaf:name ?name.
   
}
EOL
sparql = SPARQL::Client.new("http://bnb.data.bl.uk/sparql")    
results = sparql.query(QUERY)   

CSV.open( File.join(dir, "..", "data", "published-in-bath.csv"), "w") do |csv|
  csv << [ "id", "uri", "title", "published", "isbn", "author" ]
  results.each do |result|
    csv << [ result[:bnb], result[:book], result[:title], result[:timeLabel], result[:isbn], result[:name] ]
  end  
end
