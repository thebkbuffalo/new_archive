class Archive
  require 'open-uri'
  require 'zlib'
  require 'yajl'
  require 'JSON'
  require 'pry'
  require 'google/api_client'
  require 'google/api_client/client_secrets'
  require 'google/api_client/auth/installed_app'
  require 'big_query'
  require 'gcloud'

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
    get_data
  end

  def get_input
    puts 'Find the most active repo in a given time frame'
    puts 'example:'
    puts '2012-11-01 13:00:00, 2012-11-02 15:12:14, PushEvent, 42'
    input = gets.chomp.delete(' ').split(',')
    params = []
    input.each {|x| params.push(x)}
    @start = params[0]
    @end = params[1]
    @event = params[2]
    @amount = params[3]
  end

  def get_data
    opts = {}
    opts['client_id'] = '467394000337-0vbsg406ur7heob3lkkb72euvdcc3v0j.apps.googleusercontent.com'
    opts['service_email'] = ''
    opts['key'] = 'zLDUcU6sjESsreYCWuhK0Dig'
    opts['project_id'] = '467394000337'
    # gcloud = Gcloud.new 467394000337
    # bg = gcloud.bigquery
    bg = BigQuery.new(opts)
    @hash = bq.query(
      "SELECT repository_name, count(repository_name) as pushes, repository_description, repository_url
      FROM [githubarchive:github.timeline]
      WHERE type='#{@event}'
      AND repository_language='Ruby'
      AND PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('#{@after}')
      AND PARSE_UTC_USEC(created_at) < PARSE_UTC_USEC('#{@before}')
      GROUP BY repository_name, repository_description, repository_url
      ORDER BY pushes DESC
      LIMIT #{@amount}"
    )
    puts @hash
  end


end #ends class

Archive.new
