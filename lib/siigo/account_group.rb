class Siigo::AccountGroup

    def fetch(token, path)

        resource = "account-groups"
        url = 'https://api.siigo.com/v1/' + resource
        response = RestClient.get url, {:Authorization => token}
        account_groups = JSON.parse(response.body)
        
        headers = ["id", "name", "active"]
        CSV.open(path, "w") do |csv|
            csv << headers
        
            account_groups.each do |account_group|
                csv << [String(account_group["id"]), 
                        String(account_group["name"]), 
                        String(account_group["active"])]
            end
        end
    end
    
end

