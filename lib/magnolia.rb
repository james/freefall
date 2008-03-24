#!/usr/bin/env ruby

#
# = A Magnolia API class
#
# This is a library, to be used by Ruby programs,
# with the purpose of accessing the Web API of
# ma.gnolia.com.
#
# For documentation and examples, see the Magnolia::API page.
#
# == MIT License
#
# Copyright (c) 2006 Dag Odenhall <dag.odenhall@gmail.com>
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
# OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
# WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#

if $PROGRAM_NAME.eql? __FILE__
  puts "This is a library, not an application."
  exit
end

begin
  require 'net/https'
rescue LoadError
  require 'net/http'
end
require 'rexml/document'
require 'time'

#
# Raised when trying to use SSL and net/https is not installed.
#
# Example:
#
#    begin
#      mgn = Magnolia::API.new("foo", true)
#    rescue NoSSLSupportError
#      mgn = Magnolia::API.new("foo", false)
#      warn "warning: ssl not supported and will not be used"
#    end
#
# Note: To get SSL working on ubuntu and debian, which are the
# only systems I know that doesn't ship ruby SSL-ready, you
# will need to run this command:
#
#    sudo apt-get install libopenssl-ruby1.8
#
class NoSSLSupportError < Exception
  def initialize #:nodoc:
    @message = "ssl is not supported on this system"
  end
  attr_reader :message
end

#
# Container module for the Magnolia::API class.
# 
module Magnolia
  
  #
  # = Magnolia::API
  #
  # == API key
  #
  # You need to enable "application access"
  # for your account. This will generate a
  # random "api key" for you, which is used
  # by this class to access your account.
  #
  # When logged in at Magnolia, go to
  # http://ma.gnolia.com/account/advanced
  # and click "ENABLE API ACCESS".
  #
  # The key is the hexadecimal string above
  # the buttons.
  #
  # In case your key is compromise, simply
  # click the "RESET APPLICATION ACCESS"
  # button at this webpage and a new key
  # will be generated.
  # 
  # == Example
  # 
  #    # initialize api object
  #    require 'magnolia/api'
  #    mgn = Magnolia::API.new("your_api_key")
  #    
  #    # get a bookmark
  #    bookmark = mgn.get(:whemaqivo).first
  #
  #    # where does it lead?
  #    bookmark.url.to_s #=> "http://www.ruby-lang.org/en/"
  #
  #    # bookmark description
  #    bookmark.description #=> "The official Ruby website"
  #
  #    # what year was it added?
  #    bookmark.created.year #=> 2006
  #
  #    # we could've done more things with the bookmark object,
  #    # see the documentation for Magnolia::Bookmark
  #
  #    # how many people have bookmarked http://google.com/ ?
  #    mgn.find(:url => 'http://google.com/').length #=> 162
  #
  #    # please note that the above code will actually retrieve
  #    # 162 bookmarks from magnolia and may waste some
  #    # of their bandwidth, so take care
  #
  #    # delete the bookmark we retreived with Magnolia::API#get
  #    mgn.delete(bookmark.id) #=> ["whemaqivo"]
  #
  #    # i own the "whemaqivo" bookmark though,
  #    # so only i can remove it
  #
  #    # lets add it back
  #    id = mgn.add bookmark.url, :title => bookmark.title,
  #      :tags => :ruby, :description => bookmark.description
  #
  #    # we don't like that title
  #    mgn.update id, :title => 'Ruby: Cute Coding'
  #
  #    # it should have more tags
  #    mgn.add_tags id, :programming, :scripting
  #
  #    # but not scripting...
  #    mgn.delete_tags id, :scripting
  #
  #    # perhaps "programming" should've been "coding"?
  #    mgn.replace_tag id, :programming, :coding
  #
  class API
    
    VERSION = '0.1.0'
    
    #
    # This exception is raised whenever the API
    # returns an error. A list of all errors
    # that can be raised can be found at
    # http://ma.gnolia.com/support/api/errors.
    #
    # Every raised exception holds three
    # attributes:
    #
    # * +code+ is the error code, a +Fixnum+.
    # * +text+ is the error message, a +String+.
    # * +message+ is a display friendly message, a +String+.
    #
    class RequestError < Exception
      attr_reader :code, :text
      def initialize(code, text) #:nodoc:
        @code, @text = code, text
      end
    end # class RequestError
    
    #
    # Creates a new Magnolia::API instance
    # that can be used to access the magnolia API.
    #
    # * +key+ is the api key for your account,
    #   defaults to +nil+.
    # * +use_ssl+ is +nil+ or +false+ if you don't
    #   want to use a secure connection to the api,
    #   this argument defaults to +true+.
    # * +proxy_addr+ is the address to a proxy
    #   to connect through, defaults to +nil+
    #   (no proxy).
    # * +proxy_port+ is the port on the proxy
    #   to connect to, defaults to +3128+
    #   (only +proxy_addr+ needs to be +nil+
    #   to disable the proxy support).
    # * +proxy_user+ is the username to use
    #   for authenticating to the proxy,
    #   defaults to +nil+ (no authentication).
    # * +proxy_pass+ is the password to use
    #   together with +proxy_user+ for
    #   authentication, also defaults to +nil+.
    #
    #
    def initialize(key=nil, use_ssl=true, proxy_addr = nil, proxy_port = 3128, proxy_user = nil, proxy_pass = nil)
      @key = key.to_s
      self.use_ssl = use_ssl
      @proxy_addr, @proxy_port = (proxy_addr == nil ? nil : proxy_addr.to_s), proxy_port.to_i
      @proxy_user, @proxy_pass = proxy_user.to_s, proxy_pass.to_s
    end
    attr_accessor :key, :proxy_addr, :proxy_port, :proxy_user, :proxy_pass
    attr_reader :use_ssl
    
    #
    # Set whether to use SSL or not. Only reason
    # why I didn't use attr_accessor instead is
    # that this method needs to raise the
    # +NoSSLSupportError+ in case you don't
    # have net/https installed.
    #
    def use_ssl=(use_ssl)
      if use_ssl
        if $LOADED_FEATURES.include? "net/https.rb"
          @use_ssl = true
        else
          raise NoSSLSupportError
          @use_ssl = false
        end
      else
        @use_ssl = false
      end
    end
    
    #
    # Execute the specified API method with the specified arguments
    # and parse the responding XML data.
    #
    # You will only need this method if the Magnolia API has a
    # new method that this library do not yet support -
    # this method will return a REXML::Document object ready
    # to be parsed, when an unknown method is specified.
    #
    # Example of such usage:
    #
    #    doc = mgn.request(:some_new_shiny_method, :foo => "bar")
    #    foo = doc.root.elements["foo"].text
    #
    # The library will handle SSL, proxy tunneling, api key and all
    # that for you, but with an unknown method you will need to
    # parse the XML yourself.
    #
    def request(method, args)
      args.each_key {|key| args[key] = args[key].join(",") if args[key].is_a? Array }
      args[:api_key] = @key if @key.match(/^[a-zA-Z0-9]{40}$/) and not method.to_s.match("^get_key|echo$")
      h = Net::HTTP::Proxy((@proxy_addr == nil ? nil : @proxy_addr.to_s), @proxy_port.to_i, \
       @proxy_user.to_s, @proxy_pass.to_s).new("ma.gnolia.com", (@use_ssl ? 443 : 80))
      h.use_ssl = true if @use_ssl
      h.verify_mode = OpenSSL::SSL::VERIFY_NONE if @use_ssl
      h.start do |http|
        req = Net::HTTP::Post.new("/api/rest/1/#{method}")
        req.form_data = args
        res = http.request(req)
        doc = REXML::Document.new(res.body)
        if doc.root.attributes["status"].eql? "fail"
          code = doc.elements["response/error"].attributes["code"]
          text = doc.elements["response/error"].attributes["message"]
          raise RequestError.new(code.to_i, text), "error ##{code}: #{text}"
        else
          case method
          when :get_key
            return doc.root.elements["key"].text
          when :bookmarks_get, :bookmarks_find
            bookmarks = Array.new
            doc.elements.each("response/bookmarks/bookmark") do |element|
              tags = Array.new
              element.elements["tags"].elements.each("tag") {|tag| tags.push(tag.attributes["name"]) }
              bookmark = {
                :id => element.attributes["id"],
                :created => element.attributes["created"],
                :updated => element.attributes["updated"],
                :rating => element.attributes["rating"],
                :private => element.attributes["private"],
                :owner => element.attributes["owner"],
                :title => element.elements["title"].text,
                :url => element.elements["url"].text,
                :description => element.elements["description"].text,
                :screenshot => element.elements["screenshot"].text,
                :tags => tags
              }
              bookmarks.push(Magnolia::Bookmark.new(bookmark))
            end
            return bookmarks
          when :bookmarks_delete
            bookmarks = Array.new
            doc.elements.each("response/bookmarks/bookmark") do |element|
              bookmarks.push(element.attributes["id"])
            end
            return bookmarks
          when :bookmarks_add, :bookmarks_update
            return doc.elements["response/bookmarks/bookmark"].attributes["id"]
          when :bookmarks_tags_add, :bookmarks_tags_delete, :bookmarks_tags_replace
            return true
          else
            return doc
          end
        end
      end
    end
    
    #
    # Requests the API key corresponding to +username+.
    # For this to work properly, this needs to be done
    # over SSL, the +password+ must be correct (ofcourse)
    # and the account must have application access
    # enabled.
    #
    # Simply returns the API key as a +String+.
    #
    def get_key(username, password)
      request(:get_key, :id => username, :password => password)
    end
    
    #
    # Same as Magnolia::API#get_key but sets +@key+
    # to the returned hash.
    #
    # These are equivalent:
    #
    #    mgn.key = mgn.get_key(foo, bar)
    #
    # and
    #
    #    mgn.get_key!(foo, bar)
    #
    def get_key!(username, password)
      @key = get_key(username, password)
    end
    
    #
    # Takes any number of arguments and returns
    # an array of Magnolia::Bookmark objects.
    # The arguments are Magnolia bookmark IDs.
    #
    # Example:
    #
    #    bookmarks = mgn.bookmarks_get(:foobar, :xyzzy)
    #    bookmarks.first.id #=> "foobar"
    #    bookmarks.last.id #=> "xyzzy"
    #    bookmarks[1].title #=> "All things Xyzzy!"
    #
    # See the Magnolia::Bookmark documentation
    # for more information.
    #
    # Alias: Magnolia::API#get, Magnolia::API#get_bookmarks
    #
    def bookmarks_get(*ids)
      request(:bookmarks_get, :id => ids)
    end
    
    #
    # Finds bookmarks based on certain criterias
    # specified in an option hash +args+, and returns
    # an array of Magnolia::Bookmark objects, the results.
    #
    # These are the possible hash keys:
    #
    # * +tags+ - find bookmarks by tags
    # * +person+ - find only bookmarks from a certain account
    # * +group+ - find bookmarks sent to a group
    # * +rating+ - find only bookmarks rated atleast this
    # * +from+ - find only bookmarks from after this date
    # * +to+ - find only bookmarks from before this date
    # * +url+ - find bookmarks by URL
    # * +limit+ - maximum number of result bookmarks
    #
    # The keys are any object responding to to_s.
    #
    # Example:
    #
    #    mgn.bookmarks_find(:tags => ["ruby", "rails"], :rating => 5, :limit => 10)
    #
    # The code above would return ten toprated bookmarks
    # tagged "ruby" and "rails".
    #
    # Some notes:
    #
    # * The +tags+, +person+ and +group+ keys can all take
    #   an array of values.
    # * When multiple tags are specified, as an array,
    #   it is treated as an +and+ search.
    # * When multiple persons or groups are specified,
    #   as an array, it is treated as an +or+ search.
    # * The +to+ and +from+ keys take +Time+ objects.
    # * The method might return less than +limit+ bookmarks.
    #
    # Alias: Magnolia::API#find, Magnolia::API#find_bookmarks
    #
    def bookmarks_find(args)
      args2 = Hash.new
      args.each {|k, v| args2[k.to_s] = v}
      args2["from"] = args2["from"].xmlschema if args2.has_key? "from"
      args2["to"] = args2["to"].xmlschema if args2.has_key? "to"
      request(:bookmarks_find, args2)
    end
    
    #
    # Deletes all the specified bookmarks. They are
    # identified via their "Magnolia bookmark ID"
    # which here can be any object responding to +to_s+.
    #
    # Example:
    #
    #    mgn.bookmarks_delete(:foo, "bar")
    #    # would delete "foo" and "bar"
    #
    # Alias: Magnolia::API#delete, Magnolia::API#delete_bookmarks
    #
    def bookmarks_delete(*ids)
      request(:bookmarks_delete, :id => ids)
    end
    
    #
    # Adds a bookmark to your account. 
    # +url+ must be a valid url string after converted with +to_s+.
    # +args+ is an option hash, with these optional keys:
    #
    # * +title+ - the title of the bookmark
    # * +description+ - a description of the bookmark
    # * +private+ - privacy status of bookmark
    # * +tags+ - a list of tags related to the bookmark
    # * +rating+ - 0 to 5, how you rate this bookmark
    #
    # Example:
    #
    #    mgn.bookmarks_add("http://google.com", :title => "Google Search",
    #      :description => "A powerful and popular Search Engine",
    #      :rating => 5, :tags => [:search, :google])
    #
    # Alias: Magnolia::API#add, Magnolia::API#add_bookmark
    #
    def bookmarks_add(url, args)
      args2 = Hash.new
      args.each {|k, v| args2[k.to_s] = v}
      case args2["private"]
      when nil, false, "false"
        args2["private"] = "false"
      else
        args2["private"] = "true"
      end
      args2[:url] = url
      request(:bookmarks_add, args2)
    end
    
    #
    # Works basically like Magnolia::API#bookmarks_add,
    # but instead changes the data of an existing
    # bookmark. +id+ is the bookmark ID, +args+
    # is an options hash with the same keys as the
    # Magnolia::API#bookmarks_add method.
    #
    # Alias: Magnolia::API#update, Magnolia::API#update_bookmark
    #
    def bookmarks_update(id, args)
      args2 = Hash.new
      args.each {|k, v| args2[k.to_s] = v}
      case args2["private"]
      when nil, false, "false"
        args2["private"] = "false"
      else
        args2["private"] = "true"
      end
      args2[:id] = id
      request(:bookmarks_update, args2)
    end
    
    #
    # Adds a set of tags to an existing bookmark.
    #
    #    # add tags "foo" and "bar" to bookmark "xyzzy"
    #    mgn.add_tags(:xyzzy, :foo, :bar)
    #
    # Alias: Magnolia::API#add_tags
    #
    def bookmarks_tags_add(id, *tags)
      request(:bookmarks_tags_add, :id => id, :tags => tags)
    end
    
    #
    # Delets one or more tags from a bookmark.
    #
    #    # remove tags "foo" and "bar" from bookmark "xyzzy"
    #    mgn.delete_tags(:xyzzy, :foo, :bar)
    #
    # Alias: Magnolia::API#delete_tags
    #
    def bookmarks_tags_delete(id, *tags)
      request(:bookmarks_tags_delete, :id => id, :tags => tags)
    end
    
    #
    # Replace tag +old+ with tag +new+ for
    # bookmark +id+.
    #
    #    # it turns out, the "xyzzy" bookmark is
    #    # really not about ruby, but perl. blasphemy!
    #    mgn.replace_tag(:xyzzy, :ruby, :perl)
    #
    # Alias: Magnolia::API#replace_tag
    #
    def bookmarks_tags_replace(id, old, new)
      request(:bookmarks_tags_replace, :id => id, :old => old, :new => new)
    end
    
    alias :get :bookmarks_get
    alias :get_bookmarks :bookmarks_get
    alias :find :bookmarks_find
    alias :find_bookmarks :bookmarks_find
    alias :delete :bookmarks_delete
    alias :delete_bookmarks :bookmarks_delete
    alias :add :bookmarks_add
    alias :add_bookmark :bookmarks_add
    alias :update :bookmarks_update
    alias :update_bookmark :bookmarks_update
    alias :add_tags :bookmarks_tags_add
    alias :delete_tags :bookmarks_tags_delete
    alias :replace_tag :bookmarks_tags_replace
    
  end # class API
  
  #
  # This class keeps information about bookmarks.
  # Instances of this class is returned by several
  # Magnolia::API methods.
  #
  #    bookmarks = mgn.find(:tags => "ruby", :limit => 5) #=> array of up to five Magnolia::Bookmark instances
  #    bookmarks.first.id #=> magnolia id number of first bookmark in the form of a String
  #    bookmarks.first.created #=> a Time object of when this bookmark was added
  #    bookmarks.first.updated #=> a Time object of when this bookmark was last updated
  #    bookmarks.first.rating #=> the rating of this bookmark (0-5) as a Fixnum
  #    bookmarks.first.private #=> if this bookmark is private or not (TrueClass or FalseClass)
  #    bookmarks.first.owner #=> a String of which user the bookmark belongs to
  #    bookmarks.first.title #=> title of bookmark, a String
  #    bookmarks.first.url #=> the bookmarked webpage, an URL object 
  #    bookmarks.first.description #=> the description of the bookmark, a String
  #    bookmarks.first.screenshot #=> URL object pointing to the girafa screenshot of #url
  #    bookmarks.first.tags #=> array of the tags set for this bookmark (String instances)
  #
  # TODO: add attribute writers that actually change the bookmark at magnolia
  # IDEA: this should probably be done offline with an update method (bandwidth savior)
  #
  class Bookmark
    def initialize(bookmark) #:nodoc:
      @id = bookmark[:id].to_s
      if bookmark[:created].class == Time
        @created = bookmark[:created]
      else
        @created = Time.xmlschema(bookmark[:created].to_s)
      end
      if bookmark[:updated].class == Time
        @updated = bookmark[:updated]
      else
        @updated = Time.xmlschema(bookmark[:updated].to_s)
      end
      @rating = bookmark[:rating].to_i
      if bookmark[:private]
        @private = true
      else
        @private = false
      end
      case bookmark[:private]
      when "false", false, nil
        @private = false
      else
        @private = true
      end
      @owner = bookmark[:owner].to_s
      @title = bookmark[:title].to_s
      @url = URI.parse(bookmark[:url].to_s)
      @description = bookmark[:description].to_s
      @screenshot = URI.parse(bookmark[:screenshot].to_s)
      @tags = bookmark[:tags].to_a
    end
    attr_reader :id, :created, :updated, :rating, :private, :owner
    attr_reader :title, :url, :description, :screenshot, :tags
  end # class Bookmark
end # module Magnolia
