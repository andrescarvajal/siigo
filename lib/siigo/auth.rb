class Siigo::Auth
  
    def authenticate(user, password)
        puts "Starting authentication with Siigo"

        url = 'https://api.siigo.com/auth'
        payload = {
                  "username": user,
                  "access_key": password 
        }.to_json
        headers = {
          content_type: :json, accept: :json
        }
      
        begin 
          response = RestClient.post(url, payload, headers)
          puts "Authentication successful"
          puts ""
          return JSON.parse(response.body)["access_token"]
        rescue => e1
            puts "Enter in rescue"
            puts JSON.parse(e1.response)
            puts JSON.parse(e1.response)["Status"]
        end
    end

end
