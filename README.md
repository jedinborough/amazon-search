# amazon-search

Amazon Search is a simple Ruby tool to search for Amazon products.

This tool screenscrapes an Amazon search and returns a hash of the product results. Configuration of Amazon's API is not needed.

The functionality is centered around mechanize pagination for the screen scraping of nokogiri elements.  XPath and CSS selectors are currently being used.  In the event that Amazon updates their site, the selectors will need to be updated.

## DATA COLLECTED
* title
* price
* stars
* reviews
* image_href
* url
* seller


## INSTALLATION

```
  $ gem install amazon-search
```

## EXAMPLE

```ruby
    require 'amazon-search'
    
    # search for products by string

    Amazon::search "ruby"


    # search results are stored in global variable:

    $products # => returns entire hash of products found in search


    # reference any product by the order it appeared in search results


    $products[0] # => references the first product found in search
    $products[30] # => references the 29th product found in search


    # display attributes of specific product
    # all available attributes are:

    $products[0][:title] # => the first product's title
    $products[0][:price] # => etc...
    $products[0][:stars]
    $products[0][:reviews] 
    $products[0][:image_href]
    $products[0][:url]
    $products[0][:seller] 


    # Save search results in order to execute another search
    ### method 1)

    example_search = Amazon::search "ruby" 

    ### method 2)

    example_search = $products # => only works after search has been done


    # Iterate over all search results and return specific attributes

    $products.each do |x|
    	product = x[1] # => index into array before keying hash
    	puts product[:title]
    	puts product[:stars]
    	# etc ...
    end
```
	
    
## MIT LICENSE

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.