class Siigo::Customer

    def fetch(token, output_path)
        puts "Starting to fetch customers from Siigo"

        resource_tag = "customers"

        tools = Siigo::Tools.new
        resource_size = Float(tools.get_size(resource_tag, token))
        puts "The Siigo database has " + String(Integer(resource_size)) + " " + resource_tag
        page_size = 100
        page_amount = (resource_size/Float(page_size)).ceil()
        page_amount = page_amount.ceil()

        #puts "The Siigo database has " + String(page_amount) + " pages of " + resource_tag        
        url = 'https://api.siigo.com/v1/' + resource_tag

        resources = []
        resources_all_local = []
        diff_prom = 0

        # Related to the time needed for the task
        time_last = Time.now

        #for i in (page_amount).downto(1)
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

        #puts "All resources local that were fetched"
        #puts resources_all_local.count
        #puts resources_all_local[14]

        headers = ["id", "identification", "name", "created_at"]
        CSV.open(output_path, "w") do |csv|
            csv << headers
        
            resources_all_local.each do |resource_local|
                csv << [String(resource_local["id"]), 
                        String(resource_local["identification"]), 
                        String(resource_local["name"]),
                        String(resource_local["metadata"]["created"])]
            end
        end

        # puts String(account_groups.count) + " account groups were written to the file ✅"
        # puts ""
    end
    
end