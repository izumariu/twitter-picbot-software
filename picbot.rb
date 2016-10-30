#!/usr/bin/ruby

require 'net/http'
require 'nokogiri'
require 'open3'
require 'json'
require 'base64'
require 'time'
require 'cgi'
require './twitter-ruby.rb'
load './data.rb'
include Net

_st = "" # search term here, will be escaped by CGI

_q = CGI.escape(_st)
t = TwitterAPI.autoConstruct

# |||                   |||
# VVV {NOT WORKING YET} VVV

=begin
Thread.new{
	loop {
		t.getFollowerList["users"].each do |user|
			puts "Following @#{user["screen_name"]}(#{user["id"]})"
			t.followUser("user_id"=>user["id"])
		end
	}
}
=end

loop do
	puts "Waiting......"
	until Time.now.to_s.split(" ")[1].match(/\d{2}:\d2:00/)!=nil;end 
		# line above: time check no.1, after the condition is true, the picture is uploaded into the Twitter picture database
		# recommended by author: 3 min before actually posting the picture
	_rpre = Nokogiri::HTML(HTTP.get(URI("http://www.zerochan.net/#{_q}")))
	_rnd = _rpre.css('p[class="pagination"]').children.select{|i|i.to_s.match(/page 1 of \d+/)}[0].to_s[2,50].chop.split(" ")[-1].to_i
	begin
		_rnd>100 ? randpage=Random.rand(88888888)+11111111 randpage=Random.rand(_rnd)+1
		puts "Random number: #{randpage}"
		begin
			if _rnd>100
				p "http://www.zerochan.net/#{_q}?o=#{randpage}"
				res_rand = Nokogiri::HTML(HTTP.get(URI("http://www.zerochan.net/#{_q}?o=#{randpage}")))
			else
				p "http://www.zerochan.net/#{_q}?p=#{randpage}"
				res_rand = Nokogiri::HTML(HTTP.get(URI("http://www.zerochan.net/#{_q}?p=#{randpage}")))
			end
		rescue
			sleep 5
			retry
		end
		pics = res_rand.css('ul[id="thumbs2"]').css('li')
		randpic = pics[Random.rand(pics.length)]
		pic_final_res = Nokogiri::HTML(HTTP.get(URI("http://www.zerochan.net#{randpic.css('a').attribute('href').value}")))
		pic_final = pic_final_res\
			.css('div[id="wrapper"]').css('div[id="body"]').css('div[id="content"]').css('div[id="large"]').css("a").attribute("href").value
		if system("wget -O current_pic.#{pic_final.split(".")[-1]} #{pic_final}")
			p Base64.encode64(File.open("current_pic.#{pic_final.split(".")[-1]}","rb").read)
			media_id = JSON.parse(t.uploadImage("./current_pic.#{pic_final.split(".")[-1]}").body)["media_id"]
			p media_id
			puts "Finished uploading."
			until Time.now.to_s.split(" ")[1].match(/\d{2}:\d5:00/)!=nil;end
				# line above: time check no.2, after condition is true, the pic will be posted
			puts "Tweeting...."
			p JSON.parse(t.updateStatus("status"=>"http://www.zerochan.net#{randpic.css('a').attribute('href').value}","media_ids"=>media_id).body)
			puts "Tweeting complete."
		end
	rescue => e
		puts e.message
		retry
	end
	#exit(01)
end
