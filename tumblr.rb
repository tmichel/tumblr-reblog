#!/usr/bin/env ruby

# 'reblog as is' client for tumblr

require 'net/http'
require 'rexml/document'
require 'optparse'

include REXML
include Net

# parsing command line arguments

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: tumblr.rb [options]"
  
  opts.on("-e", "--email EMAIL", "Specified user email") do |e|
    options[:email] = e
  end
  
  opts.on("-p", "--password PASSWORD", "Specified user password") do |p|
    options[:password] = p
  end
  
  opts.on("-i", "--id ID", "Specifies post's id to reblog") do |id|
    options[:id] = id
  end
  
  opts.on("-b", "--blog BLOGNAME", "Secifies a tumblr blog") do |host|
    options[:host] = host
  end
  
  opts.on_tail("-?", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

# reading confing file

if File.exists?('tumblr.conf')
  f = File.read('tumblr.conf')
  opts = Hash[*f.split("\n").map{|s| s.split("=")}.flatten]
  options[:email] ||= opts["email"]
  options[:password] ||= opts["password"]
end
  

# getting the reblog key for the post

res = HTTP.get_response("#{options[:host]}.tumblr.com", "/api/read?id=#{options[:id]}")
if res.is_a?(Net::HTTPFound) || res.is_a?(HTTPMovedPermanently)
  newloc = res.fetch("location")
  res = HTTP.get_response(host, newloc)
elsif !res.is_a?(Net::HTTPSuccess)
  puts "There was an error when trying to access #{options[:host]}"
  puts "#{res.code}: #{res.message}"
  exit
end

doc = Document.new res.body
post = doc.root.elements["posts/post"]
reblog_key = post.attributes["reblog-key"]

puts "successfully got reblog key"

# reblogging the post

# http://www.tumblr.com/api/reblog
# email - Your account's email address.
# password - Your account's password.
# post-id - The integer ID of the post to reblog.
# reblog-key - The corresponding reblog-key value from the post's /api/read XML data.

email = options[:email]

data = {"email"=> email, "password" => options[:password], "post-id"=> options[:id], "reblog-key"=>reblog_key}
path = URI("http://tumblr.com/api/reblog")
res = HTTP.post_form(path, data)
puts "#{res.code}: #{res.message}"




