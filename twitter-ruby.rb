#!/usr/bin/ruby

class TwitterAPI
	@moduleerrors=false
	require 'net/http'
	require 'json' rescue (puts "No JSON module found.";@moduleerrors=true)
	require 'oauth' rescue (puts "No OAuth module found.";@moduleerrors=true)
	require 'cgi' rescue (puts "No CGI module found.";@moduleerrors=true)
	include Net

	@moduleerrors&&(puts "^^--Please install the missing modules--^^";raise RuntimeError)

	private
	
	def ensureArgs(spec);return false unless spec.is_a?(Hash);spec.each_key{|k|(raise(ArgumentError, "Request parameters not in a hash")) unless k.is_a?(spec[k])};return true;end
	def key?(a,k);a[k]==nil ? false : true;end
	def updatePost(*k);rqs=Hash.new;k.each{|hk|rqs[hk]=k[hk] if k[hk]!=nil};return rqs;end
	def paramsGetRq(domain,path,params)
		return URI(String(domain<<"#{path}?".concat(params.collect{|k,v|"#{k}=#{CGI::escape(v.to_s)}" unless v==nil}.join('&'))))
	end
	
	
	public
	def initialize(c,a)
		@CONSUMER=c;@APITOKEN=a;@f4f=false
		url = URI("https://api.twitter.com/1.1/account/verify_credentials.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		raise("Invalid credentials") if response.code[0]=='4'
		raise("Server goofed up") if response.code[0]=='5'
	end

#ctg######
# search #
##########

	def search(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/search/tweets.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
#ctg########
# statuses #
############

	def getTimelineMentions(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/statuses/mentions_timeline.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getUserTimeline(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/statuses/user_timeline.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getHomeTimeline(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/statuses/home_timeline.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getRetweetsOfMe(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/statuses/retweets_of_me.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getRetweetsById(params={})
		ensureArgs({params => Hash})
		id = params["id"];params["id"]=nil
		url = paramsGetRq("https://api.twitter.com","/1.1/statuses/retweets/#{id}.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def showStatusById(params={})
		ensureArgs({params => Hash})
		id = params["id"];params["id"]=nil
		url = paramsGetRq("https://api.twitter.com","/1.1/statuses/show/#{id}.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def destroyStatusById(params={})
		ensureArgs({params => Hash})
		id = params["id"];params["id"]=nil
		url = URI("https://api.twitter.com/1.1/statuses/destroy/#{id}.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def updateStatus(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/statuses/update.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(params)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def retweetStatusById(params={})
		ensureArgs({params => Hash})
		id = params["id"];params["id"]=nil
		url = URI("https://api.twitter.com/1.1/statuses/retweet/#{id}.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def unretweetStatusById(params={})
		ensureArgs({params => Hash})
		id = params["id"];params["id"]=nil
		url = URI("https://api.twitter.com/1.1/statuses/unretweet/#{id}.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getStatusOembed(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://publish.twitter.com","/oembed.json",params)
		response = HTTP.get(url)
		return response
	end
	def getRetweeterIds(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/statuses/retweeters/ids.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def lookupStatus(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/statuses/lookup.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(params)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
#ctg################
#  direct messages #
####################

	def getSentMessages(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/direct_messages/sent.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def showMessage(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/direct_messages/show.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getMessages(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/direct_messages.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def destroyMessageById(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/direct_messages/destroy.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def newDirectMessage(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/direct_messages/new.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
#ctg###########
# friendships #
###############
	
	def getFriendsNoRtsIds(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friendships/no_retweets/ids.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getIncomingFriendships(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friendships/incoming.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getOutgoingFriendships(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friendships/outgoing.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def followUser(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friendships/create.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def unfollowUser(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friendships/destroy.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def updateFriendships(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friendships/update.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def showFriendships(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friendships/show.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def lookupFriendships(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friendships/lookup.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
#ctg###################
# friends / followers #
#######################

	def getFriendIds(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friends/ids.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getFollowerIds(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/followers/ids.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getFriendList(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/friends/list.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getFollowerList(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/followers/list.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end

#ctg#######
# account #
###########

	def postAccountSettings(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/account/settings.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def updateProfile(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/account/update_profile.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def updateProfileImage(params={})
		raise("Sorry, \"#{__method__}\" is not available yet. I'm working on it.")
		#/account/update_profile_image.json
	end
	
#ctg######
# blocks #
##########
	
	def getBlockList(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/blocks/list.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getBlockIds(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/blocks/ids.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def blockUser(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/blocks/create.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def unblockUser(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/blocks/destroy.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
#ctg#####
# users #
#########

	def lookupUsers(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/users/lookup.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def showUser(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/users/show.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def searchUsers(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/users/search.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getUserSugSlug(params={})
		ensureArgs({params => Hash})
		slug = params["slug"];params["slug"]=nil
		url = paramsGetRq("https://api.twitter.com","/1.1/users/suggestions/#{slug}.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getUserSuggestions(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/users/suggestions.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getUserSugSlugMembers(params={})
		ensureArgs({params => Hash})
		slug = params["slug"];params["slug"]=nil
		url = paramsGetRq("https://api.twitter.com","/1.1/users/suggestions/#{slug}.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def reportSpam(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/users/report_spam.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	
#ctg#########
# favorites #
#############

	def getFavoritesList(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/favorites/list.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def favor(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/favorites/create.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def unfavor(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/favorites/destroy.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	
#ctg#####
# lists #
#########

	def getLists(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/list.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getStatusesList(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/statuses.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def addListMember(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/members/create.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def removeListMember(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/members/destroy.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getListMemberships(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/memberships.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getListSubscribers(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/list/subscribers.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def subscribeUserToList(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/lists/subscribers/create.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def showListSubscribedUser(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/subscribers/show.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def removeSubscriberFromList(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/lists/subscribers/destroy.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def addUsersToList(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/lists/members/create_all.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def removeUsersFromList(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/lists/members/destroy_all.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def showListMember(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/members/show.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getListMembers(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/members.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def createList(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/lists/create.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def updateList(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/lists/update.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def destroyList(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/lists/destroy.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end
	def showList(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/show.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getListSubscriptions(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/subscriptions.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getListOwnerships(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/lists/ownerships.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end

#ctg##############
# saved searches #
##################

	def getSavedSearchesList(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/saved_searches/list.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def showSavedSearchById(params={})
		ensureArgs({params => Hash})
		id = params["id"];params["id"]=nil
		url = paramsGetRq("https://api.twitter.com","/1.1/saved_searches/show/#{id}.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def createSavedSearch(params={})
		ensureArgs({params => Hash})
		url = URI("https://api.twitter.com/1.1/saved_searches/create.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def deleteSavedSearch(params={})
		ensureArgs({params => Hash})
		id = params["id"];params["id"]=nil
		url = URI("https://api.twitter.com/1.1/saved_searches/destroy/#{id}.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.set_form_data(updatePost)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
#ctg###
# geo #
#######

	def getGeoInfo(params={})
		ensureArgs({params => Hash})
		id = params["place_id"];params["place_id"]=nil
		url = paramsGetRq("https://api.twitter.com","/1.1/geo/id/#{place_id}.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getReverseGeocode(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/geo/reverse_geocode.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def searchGeo(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/geo/search.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
#ctg######
# trends #
##########

	def getTrendsByWoeid(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/trends/place.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getAvailableTrends(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/trends/available.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getClosestToTrends(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/trends/closest.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
######ctg######
# application #
###############

	def getAppRateLimitStatus(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/application/rate_limit_status.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
#ctg####
# help #
########

	def getConfig(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/help/configuration.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getSupportedLangs(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/help/languages.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getPrivacyPolicy(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/help/privacy.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	def getTermsOfService(params={})
		ensureArgs({params => Hash})
		url = paramsGetRq("https://api.twitter.com","/1.1/help/tos.json",params)
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Get.new(url.request_uri)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response
	end
	
#ctg#####
# media #
#########

	def uploadImage(file)
		ensureArgs({file => String})
		require 'base64'
		enc = Base64.encode64(File.open(file,"rb").read)
		url = URI("https://upload.twitter.com/1.1/media/upload.json")
		http = HTTP.new(url.host, url.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER
		request = HTTP::Post.new(url.request_uri)
		request.content_type = 'multipart/form-data'
		request.set_form_data("media"=>enc)
		request.oauth!(http,@CONSUMER,@APITOKEN)
		response=nil;http.start{response=http.request(request)}
		return response	
	end

#etc
	private;def fl
		loop do
			getFollowerList["users"].each do |user_current|
				followUser("user_id" => user_current["id"])
				puts "Followed @#{user_current["screen_name"]}(#{user_current["id"]})"
			end
			sleep 10
		end
	end;public
	
	def self.autoConstruct
		return self.new(($consumer_key||OAuth::Consumer.new("","")),($access_token||OAuth::Token.new("","")))
	end
	
	attr_reader :f4f
	def f4f=(v)
		v==true||v==false ? @f4f=v : raise(ArgumentError, "Not a bool")
		@f4f ? @@follower_listen=Thread.new{fl} : (@@follower_listen.kill rescue nil)
	end
end
