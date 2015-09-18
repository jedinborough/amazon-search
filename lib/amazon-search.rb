#!/usr/bin/env ruby

require 'mechanize'

module Amazon

class Search
    def self.find_products(keywords)
        #--------- submit the search form with keywords ---------------------
        agent = Mechanize.new{ |a|  a.user_agent_alias = "Mac Safari"} # set browser

        main_page = agent.get("http://amazon.com")
        search_form = main_page.form_with :name => "site-search" # find the search form in Amazon

        search_form.field_with(:name => "field-keywords").value = keywords # sets value of search box
        search_results = agent.submit search_form # submits form

        #--------- scan each page and store the results ---------------------
        $product_divs = []
        page_num = 0
        next_page = agent.get(search_results.uri) # initial search results are the first page

        last_page_num = search_results.search '//*[contains(concat( " ", @class, " " ), concat( " ", "pagnDisabled", " " ))]'
        last_page_num = last_page_num.text.to_i # change to int for upcoming iteration instructions

        last_page_num.times do # cycle all pages and stop on last page
            page_num += 1
            page = agent.get(next_page.uri) # load the next page
            
            $product_divs << page.search('//li[starts-with(@id, "result")]') # store the div of each product
           
            next_page_link = page.link_with text: /Next Page/ # find the next page link   
            next_page = next_page_link.click unless page_num == last_page_num # click to next page unless on last page
        end # ends pagination loop

        puts "\n\n(end of search results)"
    end


    def self.display_results
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
            
            #--------- avoid the related items gotchas ---------------------  
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

                            # errors properly avoided, now puts the results   
                            STDOUT.puts "--"*50
                            STDOUT.puts "title: \t\t#{title}"
                            STDOUT.puts "seller: \t#{seller}"
                            STDOUT.puts "price: \t\t#{price}"
                            STDOUT.puts "stars: \t\t#{stars}"
                            STDOUT.puts "reviews: \t#{reviews}"
                            STDOUT.puts "image url: \t#{image}"
                            STDOUT.puts "product url: \t#{url}"
                            
                        end # ends nil price
                    end # ends nil stars
                end # ends nil seller 
            end # ends nil product 
        end # ends each product div iteration (page is finished)    
    end # ends display_results
end # ends Search Class
end # ends Amazon Module