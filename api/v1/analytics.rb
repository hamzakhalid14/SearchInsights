require 'json'
require 'pg'

def handler(event:, context:)
  begin
    # Connect to database
    conn = PG.connect(ENV['DATABASE_URL'])

    # Get top searches
    result = conn.exec("
      SELECT sq.query, COUNT(*) as search_count
      FROM search_queries sq
      JOIN user_searches us ON sq.id = us.search_query_id
      GROUP BY sq.query
      ORDER BY search_count DESC
      LIMIT 10
    ")

    top_searches = {}
    result.each do |row|
      top_searches[row['query']] = row['search_count'].to_i
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
        top_searches: top_searches,
        total_searches: top_searches.values.sum
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
