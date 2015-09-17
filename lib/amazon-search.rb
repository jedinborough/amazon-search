#!/usr/bin/env ruby

require 'mechanize'

puts """
Example usage: 

    search \"books\"
    search \"Enders Game\" 
    search \"Rolex\"  

"""

def search(keywords)
    agent = Mechanize.new
    main_page = agent.get("http://amazon.com")
    search_form = main_page.form_with :name => "site-search" # find the search form in Amazon

    search_form.field_with(:name => "field-keywords").value = keywords # sets value of search box
    search_results = agent.submit search_form # submits form

    next_page = agent.get(search_results.uri) # initial search results are the first page

    # last page is disabled nav button in search results 
    last_page_num = search_results.search '//*[contains(concat( " ", @class, " " ), concat( " ", "pagnDisabled", " " ))]'
    last_page_num = last_page_num.text.to_i # change to int for upcoming iteration instructions

    count = 0 # start count variable

    last_page_num.times do # loop forever until stopped
        count += 1

        page = agent.get(next_page.uri) # load the next page
        
        #--------- display page number ---------------------
        # current_page = page.search '//*[contains(concat( " ", @class, " " ), concat( " ", "pagnCur", " " ))]'
        # STDOUT.puts "\n", "=="*50
        # STDOUT.puts "Displaying '#{current_page.text}' of '20' pages"
        # STDOUT.puts "This is the current page's uri:"
        # STDOUT.puts page.uri
        
        product_divs = page.search('//li[starts-with(@id, "result")]') # find the div of each product
        
        # nokogiri syntax is needed when iterating...not mechanize!
        product_divs.each do |product|
            
            #--------- nokogiri select html sections from css ---------------------
            title = product.at_css(".s-access-title")
            seller = product.at_css(".a-row > .a-spacing-none") #".a-spacing-small .a-spacing-none"
            price = product.at_css(".s-price")
            stars = product.at_css(".a-icon-star")
            reviews = product.at_css("span+ .a-text-normal") # ".a-span-last .a-spacing-mini > span+ .a-text-normal"
            image = product.at_css(".s-access-image")
            url = product.at_css(".a-row > a") 
              
            if title == nil # if it's nil it's prob an ad 
                break
            else
                title = title.text
                
                if seller == nil # if seller is nil put unknown
                    seller = "Unknown"
                else
                    seller = seller.text
                    if price == nil # no price? prob not worthy item
                    break
                    
                    else
                        price = price.text
                        if stars == nil
                            break
                            
                        else
                            stars = stars.text
                            reviews = reviews.text
                            image = image['src'] 
                            url = url['href']    
                            
                            STDOUT.puts "--"*50
                            STDOUT.puts "title: \t\t#{title}"
                            STDOUT.puts "seller: \t#{seller}"
                            STDOUT.puts "price: \t\t#{price}"
                            STDOUT.puts "stars: \t\t#{stars}"
                            STDOUT.puts "reviews: \t#{reviews}"
                            STDOUT.puts "image url: \t#{image}"
                            STDOUT.puts "product url: \t#{url}"
                            
                        end # ends nil price if statement
                    end # ends nil stars if statement
                end # ends nil seller if statement
            end # ends nil product if statement
        end # ends each product div iteration (page is finished)
       
        next_page_link = page.link_with text: /Next Page/ # find the next page link   
        next_page = next_page_link.click unless count == 20 # click to next page unless on page 20
    end # ends pagination loop

    puts "\n\n(end of search results)"
end