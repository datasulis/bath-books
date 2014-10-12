require 'rubygems'
require 'rake'
require 'rake/clean'
require 'json'
require 'dotenv'

Dotenv.load

DATA_DIR="data"

CLEAN.include ["#{DATA_DIR}/*.csv"]

task :install do
  sh %{mkdir -p vendor}
  sh %{wget -N -nd -P vendor https://github.com/socrata/datasync/releases/download/#{ENV["DATASYNC_VERSION"]}/DataSync-#{ENV["DATASYNC_VERSION"]}.jar }
end

task :published_in_bath do
  sh %{ruby bin/published-in-bath.rb}
end

task :about_bath do
  sh %{ruby bin/about-bath.rb}
end

task :upload_about_bath do
  sh %{java -jar vendor/DataSync-#{ENV["DATASYNC_VERSION"]}.jar -f data/about-bath.csv -i #{ENV["DATASET_ABOUT_BATH"]} -ph true -c config/config.json -cf config/control.json }
end

task :upload_published_in_bath do
  sh %{java -jar vendor/DataSync-#{ENV["DATASYNC_VERSION"]}.jar -f data/published-in-bath.csv -i #{ENV["DATASET_PUBLISHED_IN_BATH"]} -ph true -c config/config.json -cf config/control.json }
end

task :bl_data => [:published_in_bath, :about_bath]

task :upload_bl_data => [:prepare_config, :bl_data, :upload_about_bath, :upload_published_in_bath]
    
task :prepare_config do
  config = JSON.load( File.new("config/datasync-config-template.json") )
  config["username"] = ENV["SOCRATA_USER"]
  config["password"] = ENV["SOCRATA_PASS"]
  config["appToken"] = ENV["SOCRATA_APP_TOKEN"]
  config["logDatasetID"] = ENV["DATASET_LOGGING"]  
  File.open("config/config.json", "w") do |f|
    f.puts JSON.generate( config )
  end  
end

task :publish => [:upload_bl_data]
