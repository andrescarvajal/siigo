class Siigo::Tax

    def fetch(token, output_path)
        puts "Starting to fetch taxes from Siigo"

        resource = "taxes"
        url = 'https://api.siigo.com/v1/' + resource
        response = RestClient.get url, {:Authorization => token}
        taxes = JSON.parse(response.body)

        headers = ["id", "name", "type", "percentage", "active"]
        CSV.open(output_path, "w") do |csv|
            csv << headers
        
            taxes.each do |tax|
                csv << [String(tax["id"]), 
                        String(tax["name"]), 
                        String(tax["type"]),
                        String(tax["percentage"]), 
                        String(tax["active"])]
            end
        end

        puts String(taxes.count) + " taxes were written to the file" + "\n"
        puts ""
    end
    
end