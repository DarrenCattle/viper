# Description:
#	crypto library for viper
#
# Author:
#	darrencattle

request = require('request')

# Generic Functions

getRest = (link, message) ->
	console.log('/get ' + link)
	request.get { uri: link }, (err, r, body) -> 
		if r.statusCode == 200
			message.send(body)

getStocks = (link, message) -> 
	request.get { uri: link }, (err, r, body) -> 
		stocks = 'http://finance.google.com/finance/info?client=ig&q=' + body.substring(1,body.length-1).replace(/\s/g,'')
		request.get { uri: stocks, json: true }, (err, r, body) -> 
			truncated = body.substring(4,body.length)
			if r.statusCode == 200
				json = JSON.parse(truncated)
				dispTicker(json, message)
			if r.statusCode == 400
				message.send 'google finance does not recognize this stock'

# Crypto Functions

getCrypto = null

# Start Module Listeners

module.exports = (robot) ->

	robot.respond /cr (\S*)/i, (msg) ->
		url = 'https://api.coinmarketcap.com/v1/ticker/'
		getRest(url+msg.match[1].toString(), msg)