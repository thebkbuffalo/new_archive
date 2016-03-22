class Archive
  require 'open-uri'
  require 'zlib'
  require 'JSON'
  require 'pry'
  require 'google/api_client'
  require 'google/api_client/client_secrets'
  require 'google/api_client/auth/installed_app'
  require 'big_query'


  # gz = open('http://data.githubarchive.org/2015-01-01-12.json.gz')
  # js = Zlib::GzipReader.new(gz).read
  #
  #
  # JSON.parse(js) do |event|
  #   print event
  # end

  def initialize
    puts 'GitHub Archiver Challenge'
    # get_input
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
    # binding.pry
  end

  def get_data
    opts = {}
    opts['client_id']     = '117280968570830701807'
    opts['service_email'] = 'gharchiver@gharchiver-1257.iam.gserviceaccount.com'
    opts['key']           = 'key.p12'
    opts['project_id']    = 'gharchiver-1257'
    bq = BigQuery::Client.new(opts)

    @results = bq.query(
      # "SELECT repository_name, count(repository_name) as pushes, repository_description, repository_url
      # FROM [githubarchive:github.timeline]
      # WHERE type='#{@event}'
      # AND repository_language='Ruby'
      # AND PARSE_UTC_USEC(created_at) >= PARSE_UTC_USEC('#{@after}')
      # AND PARSE_UTC_USEC(created_at) < PARSE_UTC_USEC('#{@before}')
      # GROUP BY repository_name, repository_description, repository_url
      # ORDER BY pushes DESC
      # LIMIT #{@amount}"
      "SELECT TOP(corpus, 10) as title, COUNT(*) as unique_words " +
      "FROM [publicdata:samples.shakespeare]"
    )
    output
  end

  def output

    # repos = @results['rows']
    # repos.each do |row|
    #   puts "#{repo['f'][3]['v'][19..-1]} - #{repo['f'][1]['v']} events"
    # end
    rows = @results['rows']
    rows.each do |row|
      puts "#{row['f']}: #{row['v']}"
    end
  end


end #ends class

Archive.new
