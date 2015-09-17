
require 'mechanize'

###########################################
# Select Amazon search form and submit
# the search criteria
###########################################
agent = Mechanize.new
main_page = agent.get("http://amazon.com")
search_form = main_page.form_with :name => "site-search"

while true # until user cancels
    puts "\nPlease enter keywords for Amazon search"
    keywords = gets.chomp # asks for search terms
    search_form.field_with(:name => "field-keywords").value = keywords # sets value of search box
    search_results = agent.submit search_form # submits form
    
    
    ###########################################
    # Cycle through all result pages
    # and list product links
    ###########################################
    
    
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
        # puts "\n", "=="*50
        # puts "Displaying '#{current_page.text}' of '20' pages"
        # puts "This is the current page's uri:"
        # puts page.uri
        
        
        product_divs = page.search('//li[starts-with(@id, "result")]') # find the div of each product
        # '//li[starts-with(@id, "result")]' <-- this works but includes ads...
        
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
                
                if seller == nil # if seller is nil it's prob a movie
                    seller = "unknown"
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
                            
                            puts "--"*50
                            puts "title: \t\t#{title}"
                            puts "seller: \t#{seller}"
                            puts "price: \t\t#{price}"
                            puts "stars: \t\t#{stars}"
                            puts "reviews: \t#{reviews}"
                            puts "image url: \t#{image}"
                            puts "product url: \t#{url}"
                            
                        end # ends nil price if statement
                    end # ends nil stars if statement
                end # ends nil seller if statement
            end # ends nil product if statement
        end # ends each product div iteration (page is finished)
       
        next_page_link = page.link_with text: /Next Page/ # find the next page link
        
        next_page = next_page_link.click unless count == 20 # click to next page unless on page 20
    end 
    
    puts "\n\n(end of search results)"

end