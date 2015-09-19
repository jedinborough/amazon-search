require 'mechanize'
require_relative './products'
require_relative './form'

module Amazon
    class << self
        # examine current_pagenum
        def examine_current_pagenum
            $current_pagenum = $current_page.search '//*[contains(concat( " ", @class, " " ), concat( " ", "pagnCur", " " ))]'
            $current_pagenum = $current_pagenum.text.to_i # need integer for checks
        end

        # find last page number
        def find_last_pagenum
            $last_pagenum = $current_page.search '//*[contains(concat( " ", @class, " " ), concat( " ", "pagnDisabled", " " ))]'
            $last_pagenum = $last_pagenum.text.to_i # need integer for checks
        end


        # load next page
        def load_next_page
            puts "***started load_next_page method***"
            puts "ready to examine the page number?"
            gets

            examine_current_pagenum

            puts "page number is..."
            puts $current_pagenum
            puts "continue?"
            gets

            $next_page_link = $current_page.link_with text: /Next Page/ # find next page link

            puts "found next page..."
            puts "this is link:"
            puts $main_page.uri+$next_page_link.uri
            puts "continue?"
            gets

            $next_page = $next_page_link.click unless $current_pagenum == $last_pagenum # click to next page unless on last page

            puts "next step is to load the next page..."
            puts "page will load to:"
            puts $agent.get($next_page.uri).uri
            puts "continue?"
            gets

            $current_page = $agent.get($next_page.uri)
            examine_current_pagenum

            puts "====current_page has changed===="
            puts "this is uri:"
            puts $current_page.uri
            puts "this is page_num"
            puts $current_pagenum

            puts "\ncontinue and exit loading method?"
            gets

            puts "***ending load_next_page method***"
        end


        # cycle through search result pages and store product html
        def scan
            puts "***started scan method***"
            $pages = {}

            find_last_pagenum

            $last_pagenum.times do # paginate until on last page.
                puts "***started pagination block***"

                puts "Enter 'html' if you want to puts pages array, other press RETURN to continue"
                answer = gets.chomp

                if answer == "html"
                    if $pages.empty?
                        puts "pages array is empty"
                    else
                        $pages.each {|x| puts x}
                    end
                end

                examine_current_pagenum

                $current_divs = $current_page.search('//li[starts-with(@id, "result")]')
                $pages[$page_num] = $current_divs # store page results


                puts "--"*50
                puts "\nlast page number is #{$last_pagenum}"
                puts "we're on #{$current_pagenum}"
                puts "this is current hyperlink:"
                puts $current_page.uri


                puts "ready to go to #{$current_pagenum+1}?"
                gets

                load_next_page
                puts "scanning is ready to restart loop."
                puts "continue?"
                gets
                puts "***ending pagination block***"
            end

            puts "***ending scan method***"
        end 
    end

end