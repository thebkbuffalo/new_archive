class Archiver
  require 'open-uri'
  require 'zlib'
  require 'yajl'
  require 'JSON'
  require 'bigquery'

  # gz = open('http://data.githubarchive.org/2015-01-01-12.json.gz')
  # js = Zlib::GzipReader.new(gz).read
  #
  #
  # JSON.parse(js) do |event|
  #   print event
  # end

  def initialize
    puts 'GitHub Archiver Challenge"'
  end

  
end #ends class
