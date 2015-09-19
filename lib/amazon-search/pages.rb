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

            examine_current_pagenum # does this need to be here?

            $next_page_link = $current_page.link_with text: /Next Page/ # find next page link
            $next_page = $next_page_link.click unless $current_pagenum == $last_pagenum # click to next page unless on last page

            $current_page = $agent.get($next_page.uri)

        end


        # cycle through search result pages and store product html
        def scan
            $pages = {}

            find_last_pagenum

            $last_pagenum.times do # paginate until on last page.

                examine_current_pagenum

                $current_divs = $current_page.search('//li[starts-with(@id, "result")]')
                $pages[$page_num] = $current_divs # store page results

                load_next_page

            end
        end 
    end

end