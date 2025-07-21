require 'json'
require 'pg'

def handler(event:, context:)
  begin
    # Get user IP
    user_ip = event['headers']['x-forwarded-for'] ||
              event['headers']['x-real-ip'] ||
              event['requestContext']['identity']['sourceIp'] ||
              'unknown'

    # Connect to database
    conn = PG.connect(ENV['DATABASE_URL'])

    # Get user's search history
    result = conn.exec_params("
      SELECT sq.query, COUNT(*) as search_count
      FROM search_queries sq
      JOIN user_searches us ON sq.id = us.search_query_id
      WHERE us.user_ip = $1
      GROUP BY sq.query
      ORDER BY search_count DESC
      LIMIT 10
    ", [user_ip])

    searches = []
    result.each do |row|
      searches << [row['query'], row['search_count'].to_i]
    end

    conn.close

    {
      statusCode: 200,
      headers: {
        'Content-Type' => 'application/json',
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Allow-Headers' => 'Content-Type',
        'Access-Control-Allow-Methods' => 'GET, OPTIONS'
      },
      body: JSON.generate({
        searches: searches,
        user_ip: user_ip
      })
    }
  rescue => e
    {
      statusCode: 500,
      headers: { 'Content-Type' => 'application/json' },
      body: JSON.generate({ error: e.message })
    }
  end
end
