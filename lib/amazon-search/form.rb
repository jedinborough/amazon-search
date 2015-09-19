require 'mechanize'
require_relative './scan'
require_relative './products'

module Amazon
    class << self
        # prepares Mechanize
        def set_agent
            $agent = Mechanize.new{ |a|  a.user_agent_alias = "Mac Safari"}
        end

        # finds Amazon search box
        def find_form
            $main_page = $agent.get("http://amazon.com")
            $search_form = $main_page.form_with :name => "site-search"
        end

        # submits Amazon search box
        def submit_form
            $search_form.field_with(:name => "field-keywords").value = $keywords # sets value of search box
            $current_page =  $agent.submit $search_form # submits form

        end
    end

end