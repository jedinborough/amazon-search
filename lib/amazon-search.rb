#!/usr/bin/env ruby

require 'mechanize'
require 'amazon-search/form'
require 'amazon-search/scan'
require 'amazon-search/products'

module Amazon
    class << self
        # main method: process Amazon search
        def search(keywords)
            $keywords = keywords 

            set_agent
            find_form
            submit_form
            scan

            $products
        end
    end
end



