class Siigo::Users

    def fetch(token, output_path)
        resource_tag = "users"

        puts "Starting to fetch " + resource_tag + " from Siigo"

        tools = Siigo::Tools.new
        resource_size = Float(tools.get_size(resource_tag, token))
        puts "The Siigo database has " + String(Integer(resource_size)) + " " + resource_tag
        page_size = 100
        page_amount = (resource_size/Float(page_size)).ceil()
        page_amount = page_amount.ceil()
      
        url = 'https://api.siigo.com/v1/' + resource_tag

        resources = []
        resources_all_local = []
        diff_prom = 0

        # Related to the time needed for the task
        time_last = Time.now

        for i in 1..page_amount
            puts "Iteration " + String(i) + " of " + String(page_amount)
            #sleep 1 # To avoid problems related to high request-rates
            fetched = false
            try = 1
            while fetched != true
                begin 
                    response = tools.get_page(resource_tag, token, i, page_size)

                    if response.count != 0 #TODO: Review if this condition is a good one
                        resources = response
                        fetched = true
                        #puts "Fetched data in " + String(try) + " try"
                        try = try + 1
    
                        for j in 0..(resources.count-1)
                            resources_all_local.push(resources[j])
                        end
                    else 
                        puts "Problems with the fetched results"
                        fetched = false
                    end

                    # Related to the time needed for the task
                    time_now = Time.now
                    diff = time_now - time_last
                    diff_prom = Float(diff_prom*(i-1))/Float(i) + Float(diff)/Float(i)   
                    #diff_prom = Float(diff)/Float(i)         
                    time_last = time_now
                    #puts "Diff = " + String(diff)
                    #puts "Diff prom = " + String(diff_prom)
                    puts "Remaning time = " + String(diff_prom * (page_amount - i))

                rescue => e1
                    puts "Enter in rescue"
                    puts e1.response
                    fetched = false
                    try = try + 1
                end
            end
        end

        puts "Writing data to the file. This could take a while..."
        n = 0
        
        headers = ["id", "username", "first_name", "last_name",
                            "email", "active", "identification"]
        CSV.open(output_path, "w") do |csv|
            csv << headers
                
            resources_all_local.each do |resource_local|
                csv << [String(resource_local["id"]), 
                        String(resource_local["username"]),
                        String(resource_local["first_name"]), 
                        String(resource_local["last_name"]),  
                        String(resource_local["email"]), 
                        String(resource_local["active"]), 
                        String(resource_local["identification"])]

                n = n + 1
                if n % 1000 == 0
                    puts String(n) + " data has been written to the file"
                end

            end            
        end

        puts String(resources_all_local.count) + " " + resource_tag + " were written to the file ✅"
        puts ""
    end
    
end

