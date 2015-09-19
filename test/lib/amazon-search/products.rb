require 'mechanize'
require_relative './scan'
require_relative './form'

module Amazon
    class << self
        $products = {}
        $product_num = 0

        # used for checking strings
        def is_numeric?(s)
         !!Float(s) rescue false
        end

        # currently not being used and needs adjusting  
        def display_product
            STDOUT.puts "--"*50
            STDOUT.puts "title: \t\t#{$title}"
            STDOUT.puts "seller: \t#{$seller}"
            STDOUT.puts "price: \t\t#{$price}"
            STDOUT.puts "stars: \t\t#{$stars}"
            STDOUT.puts "reviews: \t#{$reviews}"
            STDOUT.puts "image url: \t#{$image_href}"
            STDOUT.puts "product url: \t#{$url}"
        end

        # extract product data
        def extract_product_data
            
            # nokogiri syntax is needed when iterating...not mechanize!
            # extract useful stuff from product html
            $current_divs.each do |html| 
                # first select raw html
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
                 
                # extract text and set variables for puts       
                $title = title.text      
                $price = price.text
                $stars = stars.text
                $image_href = image_href['src'] 
                $url = url['href']

                # movies sometimes have text in review class
                if is_numeric?(reviews.text)
                    $reviews = reviews.text
                else
                    $reviews = "Unknown"
                end

                if seller == nil # sometimes seller is nil on movies, etc.
                    $seller = "Unknown"
                else
                    $seller = seller.text
                end

                # don't overload the server
                sleep(0.05)

                display_product

                # store extracted text in products hash
                # key is product count
                $products[$product_num] = {
                    title: $title,
                    price: $price,
                    stars: $stars,
                    reviews: $reviews,
                    image_href: $image_href,
                    url: $url,
                    seller: $seller,
                }

                $product_num +=1 # ready for next product
            end
        end
    end
end