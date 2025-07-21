require 'json'
require 'pg'

def handler(event:, context:)
  # Parse request body
  body = JSON.parse(event['body'] || '{}')
  query = body['query']

  return {
    statusCode: 400,
    headers: { 'Content-Type' => 'application/json' },
    body: JSON.generate({ error: 'Query parameter is required' })
  } unless query

  begin
    # Get user IP
    user_ip = event['headers']['x-forwarded-for'] ||
              event['headers']['x-real-ip'] ||
              event['requestContext']['identity']['sourceIp'] ||
              'unknown'

    # Connect to database (you'll need to set DATABASE_URL in Vercel env vars)
    conn = PG.connect(ENV['DATABASE_URL'])

    # Insert search query
    search_query_result = conn.exec_params(
      "INSERT INTO search_queries (query, created_at, updated_at) VALUES ($1, NOW(), NOW()) RETURNING id",
      [query]
    )
    search_query_id = search_query_result[0]['id']

    # Insert user search
    conn.exec_params(
      "INSERT INTO user_searches (search_query_id, user_ip, created_at, updated_at) VALUES ($1, $2, NOW(), NOW())",
      [search_query_id, user_ip]
    )

    conn.close

    {
      statusCode: 200,
      headers: {
        'Content-Type' => 'application/json',
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Allow-Headers' => 'Content-Type',
        'Access-Control-Allow-Methods' => 'POST, OPTIONS'
      },
      body: JSON.generate({
        success: true,
        user_ip: user_ip,
        message: "Search tracked successfully"
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
