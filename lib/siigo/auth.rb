class Siigo

    def auth(user, password)
        url = 'https://api.siigo.com/auth'
        payload = {
                  "username": user,
                  "access_key": password 
        }.to_json
        headers = {
          content_type: :json, accept: :json
        }
      
        response = RestClient.post(url, payload, headers)
        #cookies[:siigo_api_token] = JSON.parse(response.body)["access_token"]
        return JSON.parse(response.body)["access_token"]
    end
    
end
