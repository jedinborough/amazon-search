require 'mechanize'
require_relative './pages'
require_relative './form'

module Amazon
    class << self
        # extract product data
        def extract_product_data
            # nokogiri syntax is needed when iterating...not mechanize!
            $current_divs.each do |html|
                title = html.at_css(".s-access-title")
                seller = html.at_css(".a-row > .a-spacing-none")
                price = html.at_css(".s-price")
                stars = html.at_css(".a-icon-star")
                reviews = html.at_css("span+ .a-text-normal") 
                image_href = html.at_css(".s-access-image")
                url = html.at_css(".a-row > a") 

                break if title == nil # if it's nil it's prob an ad 
                break if price == nil # no price? prob not worthy item 
                break if stars == nil # no stars? not worth it

                if seller == nil # sometimes seller is nil on movies, etc.
                    seller = "Unknown"
                else
                    seller = seller.text
                end
                 
                # extract text and set variables for puts       
                title = title.text      
                price = price.text
                stars = stars.text
                reviews = reviews.text
                image_href = image_href['src'] 
                url = url['href']

                Product.new(title, price, stars, reviews, image_href, url, html)

            end
        end


        # currently not being used and needs adjusting  
        def display_product
            STDOUT.puts "--"*50
            STDOUT.puts "title: \t\t#{title}"
            STDOUT.puts "seller: \t#{seller}"
            STDOUT.puts "price: \t\t#{price}"
            STDOUT.puts "stars: \t\t#{stars}"
            STDOUT.puts "reviews: \t#{reviews}"
            STDOUT.puts "image url: \t#{image}"
            STDOUT.puts "product url: \t#{url}"
        end



    end

end