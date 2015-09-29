require 'mechanize'

# actions of Amazon search
module Amazon
  class << self
    attr_accessor :products, :title, :price, :stars, :reviews, :seller,
                  :image_url, :product_url, :product_num

    # main method: process Amazon search
    def search(keywords)
      @keywords = keywords
      set_agent
      find_form
      submit_form
      scan
      puts 'ready to return products?'
      gets
      @products
    end

    # prepares Mechanize
    def set_agent
      @agent = Mechanize.new { |a| a.user_agent_alias = 'Mac Safari' }
    end

    # finds Amazon search box
    def find_form
      @main_page = @agent.get('http://amazon.com')
      @search_form = @main_page.form_with name: 'site-search'
    end

    # submits Amazon search box
    def submit_form
      @search_form.field_with(name: 'field-keywords').value = @keywords
      @current_page = @agent.submit @search_form # submits form
    end

    # examine current_pagenum
    def examine_current_pagenum
      @current_pagenum =
        @current_page.search '//*[contains(concat( " ", @class, " " ),
          concat( " ", "pagnCur", " " ))]'

      @current_pagenum = @current_pagenum.text.to_i # need integer for checks
    end

    # find last page number
    def find_last_pagenum
      @last_pagenum =
       @current_page.search '//*[contains(concat( " ", @class, " " ),
         concat( " ", "pagnDisabled", " " ))]'

      @last_pagenum = @last_pagenum.text.to_i # need integer for checks
    end

    # load next page
    def load_next_page
      examine_current_pagenum # does this need to be here?

      # find next page link
      @next_page_link = @current_page.link_with text: /Next Page/
      @next_page = @next_page_link.click unless @current_pagenum == @last_pagenum
      @current_page = @agent.get(@next_page.uri)
    end

    # cycle through search result pages and store product html
    def scan
      @pages = {}

      find_last_pagenum

      @last_pagenum.times do # paginate until on last page.
        examine_current_pagenum

        @current_divs = @current_page.search('//li[starts-with(@id, "result")]')
        @pages[@page_num] = @current_divs # store page results

        extract_product_data
        load_next_page
      end
      puts "\n(scan complete.)"
    end

    # used for checking strings
    def numeric?(s)
      !!Float(s) rescue false
    end

    # puts product details to console
    def display_product
      STDOUT.puts '--' * 50
      STDOUT.puts "title: \t\t#{@title}"
      STDOUT.puts "seller: \t#{@seller}"
      STDOUT.puts "price: \t\t#{@price}"
      STDOUT.puts "stars: \t\t#{@stars}"
      STDOUT.puts "reviews: \t#{@reviews}"
      STDOUT.puts "image url: \t#{@image_href}"
      STDOUT.puts "product url: \t#{@url}"
    end

    # extract product data
    def extract_product_data
      # TODO: fix this global variable...
      @products = {}
      @product_num = 0

      # nokogiri syntax is needed when iterating...not mechanize!
      # extract useful stuff from product html
      @current_divs.each do |html|
        # first select raw html
        title = html.at_css('.s-access-title')
        seller = html.at_css('.a-row > .a-spacing-none')
        price = html.at_css('.s-price')
        stars = html.at_css('.a-icon-star')
        reviews = html.at_css('span+ .a-text-normal')
        image_href = html.at_css('.s-access-image')
        url = html.at_css('.a-row > a')

        break if title.nil? == true # if it's nil it's prob an ad
        break if price.nil? == true # no price? prob not worthy item
        break if stars.nil? == true # no stars? not worth it

        # extract text and set variables for puts
        @title = title.text
        @price = price.text
        @stars = stars.text
        @image_href = image_href['src']
        @url = url['href']

        # movies sometimes have text in review class
        if numeric?(reviews.text)
          @reviews = reviews.text
        else
          @reviews = 'Unknown'
        end

        if seller.nil? == true # sometimes seller is nil on movies, etc.
          @seller = 'Unknown'
        else
          @seller = seller.text
        end

        # don't overload the server
        sleep(0.05)

        display_product

        # store extracted text in products hash
        # key is product count
        @products[@product_num] = {
          title: @title,
          price: @price,
          stars: @stars,
          reviews: @reviews,
          image_href: @image_href,
          url: @url,
          seller: @seller
        }

        @product_num += 1 # ready for next product
      end
    end
  end
end
