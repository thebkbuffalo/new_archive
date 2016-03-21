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
  # require 'gcloud'
  # require 'googleauth'
  # scopes =  ['https://www.googleapis.com/auth/bigquery']
  # authorization = Google::Auth.get_application_default(scopes)


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
    # require 'google/apis/bigquery'
    # gcloud = Gcloud.new 467394000337
    # bg = gcloud.bigquery
    opts = {}
    opts['client_id']     = '100498757788084069982'
    opts['service_email'] = 'gharchiver@appspot.gserviceaccount.com'
    opts['key']           = '70f22dd8429d6ef0c010852051682c7f082eb5d5'
    opts['project_id']    = 'gharchiver'
    bq = BigQuery::Client.new
    @hash =bq.query(
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
    output
  end


end #ends class

Archive.new
