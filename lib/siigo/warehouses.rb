class Siigo::Warehouses

    def fetch(token, output_path)
        resource_tag = "warehouses"

        puts "Starting to fetch " + resource_tag + " from Siigo"

        url = 'https://api.siigo.com/v1/' + resource_tag
        response = RestClient.get url, {:Authorization => token}
        resources = JSON.parse(response.body)

        headers = ["id", "name", "active", "has_movements"]
        CSV.open(output_path, "w") do |csv|
            csv << headers
        
            resources.each do |resource|
                csv << [String(resource["id"]), 
                        String(resource["name"]), 
                        String(resource["active"]), 
                        String(resource["has_movements"])]
            end
        end

        puts String(resources.count) + " " + resource_tag + " were written to the file ✅"
        puts ""
    end
    
end
