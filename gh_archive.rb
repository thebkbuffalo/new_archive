class Archive
  require 'open-uri'
  require 'zlib'
  require 'yajl'
  require 'JSON'
  require 'pry'
  require 'google/api_client'
  require 'google/api_client/client_secrets'
  require 'google/api_client/auth/installed_app'
  # require 'bigquery'

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
    puts '2012-11-01 13:00:00, 2012-11-02 15:12:14, PushEvent, 42'
    input = gets.chomp.delete(' ').split(',')
    @params = []
    input.each {|x| @params.push(x)}
    puts @params[0]
    puts @params[1]
    puts @params[2]
    puts @params[3]
  end

  def get_data
    gh = open('http://data.githubarchive.org')
    js = Zlib::GzipReader.new(gh).read
  end


end #ends class

Archive.new
