#!/usr/bin/env ruby

require 'mechanize'
require './amazon-search/form'
require './amazon-search/pages'
require './amazon-search/products'

module Amazon
    class << self
        def search(keywords)
            $keywords = keywords 

            set_agent
            find_form
            submit_form
            scan
        end
    end
end



