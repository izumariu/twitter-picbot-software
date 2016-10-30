require 'oauth'
$consumer_key = OAuth::Consumer.new(
	"CONSUMER KEY HERE",
	"CONSUMER SECRET HERE"
)
$access_token = OAuth::Token.new(
	"API TOKEN HERE",
	"API SECRET HERE"
)
