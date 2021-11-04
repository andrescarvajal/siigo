class Siigo::AccountGroup

    def fetch(token, output_path)
        puts "Starting to fetch account groups from Siigo"

        resource = "account-groups"
        url = 'https://api.siigo.com/v1/' + resource
        response = RestClient.get url, {:Authorization => token}
        account_groups = JSON.parse(response.body)

        headers = ["id", "name", "active"]
        CSV.open(output_path, "w") do |csv|
            csv << headers
        
            account_groups.each do |account_group|
                csv << [String(account_group["id"]), 
                        String(account_group["name"]), 
                        String(account_group["active"])]
            end
        end

        puts String(account_groups.count) + " account groups were written to the file"
        puts ""
    end
    
end

