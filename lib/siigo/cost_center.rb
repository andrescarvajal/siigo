class Siigo::CostCenter

    def fetch(token, output_path)
        puts "Starting to fetch cost centers from Siigo"

        resource = "cost-centers"
        url = 'https://api.siigo.com/v1/' + resource
        response = RestClient.get url, {:Authorization => token}
        cost_centers = JSON.parse(response.body)

        headers = ["id", "code", "name", "active"]
        CSV.open(output_path, "w") do |csv|
            csv << headers
        
            cost_centers.each do |cost_center|
                csv << [String(cost_center["id"]), 
                        String(cost_center["code"]), 
                        String(cost_center["name"]), 
                        String(cost_center["active"])]
            end
        end

        puts String(cost_centers.count) + " cost centers were written to the file ✅"
        puts ""
    end
    
end
