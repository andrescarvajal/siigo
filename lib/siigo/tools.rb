class Siigo::Tools

    def get_size(resource_tag, token)
        url = 'https://api.siigo.com/v1/' + resource_tag + '?page_size=100'
        response = RestClient.get url, {:Authorization => token}
        return JSON.parse(response.body)["pagination"]["total_results"]
    end

    def get_page(resource_tag, token, page, page_size)
        page_size = String(page_size)
        page = String(page)
        url = 'https://api.siigo.com/v1/' + resource_tag + '?page_size=' + page_size + '&page=' + page
        response = RestClient.get url, {:Authorization => token}
        return  JSON.parse(response.body)["results"]
    end

    def write_resource_to_db(resources, i, resource_tag)                      
        case resource_tag
        when 'invoices'
            if Invoice.all.find_by_id(resources[i]["id"]).nil?
                begin
                    resource_i = Invoice.new(id: resources[i]["id"],
                                    number: resources[i]["number"],
                                    date: resources[i]["date"],
                                    contact_id: resources[i]["customer"]["id"],
                                    seller: resources[i]["seller"],
                                    cost_center_id: resources[i]["cost_center"],
                                    total: resources[i]["total"],
                                    created_at: resources[i]["metadata"]["created"])
                    resource_i.save!
                    puts "Writing " + resource_tag.singularize + " " + String(i+1) + " of " + String(resources.count)
                rescue => e2
                    puts "Enter in rescue Invoice"
                    puts e2.response
                end
            else
                puts resource_tag.singularize + " " + String(resources[i]["id"]) + " was already in db"
            end
        when 'products'
            if Item.all.find_by_id(resources[i]["id"]).nil?
                begin 
                    # TODO: review a better way to import this
                    if resources[i]["taxes"].count == 1  
                        tax = resources[i]["taxes"][0]["id"]
                    else
                        tax = nil # Nothing to reference
                    end
                    resource_i = Item.new(id: resources[i]["id"],
                                    sku: resources[i]["code"],
                                    name: resources[i]["name"],
                                    account_group_id: resources[i]["account_group"]["id"],
                                    product_type: resources[i]["type"],
                                    tax_id: tax,
                                    created_at: resources[i]["metadata"]["created"])
                    resource_i.save!
                    puts "Writing " + resource_tag.singularize + " " + String(i+1) + " of " + String(resources.count)
                rescue => e2
                    puts "Enter in rescue Item"
                    puts resources[i]
                    puts e2.response
                end
            else
                puts resource_tag.singularize + " " + String(resources[i]["id"]) + " was already in db"
            end
        when 'customers'
 
            # id: resources[i]["id"],
            # identification: resources[i]["identification"],
            # name: resources[i]["name"],
            # created_at: resources[i]["metadata"]["created"])

        else
            puts "Error: Unknown resource!!"
        end
        
    end
    
end