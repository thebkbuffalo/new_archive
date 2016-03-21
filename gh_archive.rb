class Archive
  require 'open-uri'
  require 'zlib'
  require 'yajl'
  require 'JSON'
  require 'google-api-client'
  require 'bigquery'

  # gz = open('http://data.githubarchive.org/2015-01-01-12.json.gz')
  # js = Zlib::GzipReader.new(gz).read
  #
  #
  # JSON.parse(js) do |event|
  #   print event
  # end

  def initialize
    puts 'GitHub Archiver Challenge'
    get_input
  end

  def get_input
    puts 'Find the most active repo in a given time frame'
    puts 'example:'
    puts '2012-11-01, 2012-11-02, PushEvent, 42'
    input = gets.chomp.delete(' ').split(',')
  end

  def get_data
    gh = open('http://data.githubarchive.org')
    js = Zlib::GzipReader.new(gh).read
  end


end #ends class

Archive.new
