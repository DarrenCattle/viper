# Description:
#   Viper the bot useful scripts
#
# Commands:
#	viper wassup - you already know
#	molly pay viper {bet} quantum {odds} - theoretical dice game, max bet 3, odds between 0-1, payout is 99%
#	viper wealth {bet} - find viper's balance and minimum required odds, default is 1
#	viper gimme - make viper say pay me for molly, thanks
#	viper draw {cards} - draw # of cards
#	viper shuffle - shuffle cards
#	viper stocks - current list of stocks
#	viper addstock - add a legitimate stock ticker to the list
#	viper tick {AMD} - check a single stock 
#	viper ticker - display current tickers from stock list
#	viper italy - display Serie A games for current matchday
#	viper league {ID} - display soccer games for any league
#	viper leagues - list supported leagues and their corresponding ID
#	viper nahsh - enable or disable sassy nash responses
#	viper nashdrop - random phrases from nash
#	::: LISTOPHRENIC ENABLED :::
#	viper get {list} - display from list
#	viper post {list} {value} - add value to list

request = require('request')

deck = ['A:spades:', 'K:spades:', 'Q:spades:', 'J:spades:', '10:spades:', '9:spades:', '8:spades:', '7:spades:', '6:spades:', '5:spades:', '4:spades:', '3:spades:', '2:spades:', 'A:hearts:', 'K:hearts:', 'Q:hearts:', 'J:hearts:', '10:hearts:', '9:hearts:', '8:hearts:', '7:hearts:', '6:hearts:', '5:hearts:', '4:hearts:', '3:hearts:', '2:hearts:', 'A:clubs:', 'K:clubs:', 'Q:clubs:', 'J:clubs:', '10:clubs:', '9:clubs:', '8:clubs:', '7:clubs:', '6:clubs:', '5:clubs:', '4:clubs:', '3:clubs:', '2:clubs:', 'A:diamonds:', 'K:diamonds:', 'Q:diamonds:', 'J:diamonds:', '10:diamonds:', '9:diamonds:', '8:diamonds:', '7:diamonds:', '6:diamonds:', '5:diamonds:', '4:diamonds:', '3:diamonds:', '2:diamonds:']

playdeck = deck.slice(0)
drawdeck = []
houseadv = 0.9
ticker = []
leagues = ['426','430','436','439']
nash = false
admin = ["d", "rid", "thomas"]

viperdraw = (seeder) ->
	drawdeck.push(playdeck[seeder])
	playdeck.splice(seeder,1)
	return drawdeck[drawdeck.length-1]

# REST Requests

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

# Stock Requests

getTicker = (link, message) ->
	request.get { uri: link, json: true }, (err, r, body) -> 
		truncated = body.substring(4,body.length)
		if r.statusCode == 200
			json = JSON.parse(truncated)
			dispTicker(json, message)
		if r.statusCode == 400
			message.send 'google finance does not recognize this stock'

dispTicker = (ticker, message) -> 
	message.send stock.t + ' ' + stock.l + ' ' + stock.cp + '% ' + stock.c for stock in ticker

# Soccer Requests

getMatchday = (link, league, message) ->
	request.get { uri: link, json: true, "X-Auth-Token": "e5137d9c30a84d3d9ad3d0745923aa52" }, (err, r, body) -> 
		matchday = body.currentMatchday
		match_url = 'http://api.football-data.org/v1/competitions/'+league+'/fixtures?matchday='+matchday
		getFixtures(match_url, message)

getFixtures = (link, message) ->
	request.get { uri: link, json: true, "X-Auth-Token": "e5137d9c30a84d3d9ad3d0745923aa52" }, (err, r, body) -> 
		dispFixtures(body, message)

dispFixtures = (games, message) ->
	fixtures = games["fixtures"]
	for item in fixtures
		message.send item.homeTeamName + ' vs. ' + item.awayTeamName + ' at ' + new Date(item.date)

# Functional Redis

setList = (key, value, robot) ->
	list = robot.brain.get(key)
	if list is null
		list = [value]
	else 
		list.push(value)
	robot.brain.set(key, list)

removeList = (key, value, robot) ->
	list = robot.brain.get(key)
	if value in list
		result = list.filter (word) -> word isnt value
		robot.brain.set(key, result)

# Start Module Listeners

module.exports = (robot) ->

	robot.respond /PING$/i, (msg) ->
		msg.send "PONG"

	robot.respond /ECHO (.*)$/i, (res) ->
		if res.message.user.name.toLowerCase() == "d"
			echo = res.match[1]
			res.send echo
		else
			res.reply 'my owner is d'

	robot.respond /get (\S*)/i, (msg) ->
		url = 'https://listophrenic.herokuapp.com/' + msg.match[1]
		getRest(url, msg)

	robot.respond /post (\S*) (\S*)/i, (msg) ->
		#if msg.message.user.name.toLowerCase() == "d"
			url = 'https://listophrenic.herokuapp.com/post/' + msg.match[1] + '/' + msg.match[2]
			getRest(url, msg)

# Soccer Functions

	robot.respond /italy/i, (msg) ->
		msg.send "I'm italian"
		url = 'http://api.football-data.org/v1/competitions/438/'
		getMatchday(url, '438', msg)

	robot.respond /league (\S*)/i, (msg) ->
		url = 'http://api.football-data.org/v1/competitions/'+msg.match[1]
		if msg.match[1] in leagues
			getMatchday(url, msg.match[1], msg)
		else 
			msg.send 'not a valid league'

	robot.respond /leagues/i, (msg) ->
		msg.send 'Premier League: 426'
		msg.send 'Bundesliga: 430'
		msg.send 'La Liga: 436'
		msg.send 'Portugese Liga: 439'

# Persistence Testing

	robot.respond /add (\S*) (\S*)/i, (res) ->
		setList(res.match[1], res.match[2], robot)
		res.send res.match[1] + ': ' + robot.brain.get(res.match[1]).toString()

	robot.respond /show (\S*)/i, (res) ->
		if res.message.user.name.toLowerCase() != "nash"
			name = res.match[1]
			list = robot.brain.get(name)
			if list is null
				res.send name + ' is null'
			else
				res.send name + ': ' + list.toString()

	robot.respond /rm (\S*) (\S*)/i, (res) ->
		if res.message.user.name.toLowerCase() == "d"
			removeList(res.match[1], res.match[2], robot)
		res.send res.match[1] + ': ' + robot.brain.get(res.match[1]).toString()

	robot.respond /clear (\S*)/i, (res) ->
		if res.message.user.name.toLowerCase() == "d"
			robot.brain.set(res.match[1], null)
			res.send 'cleared ' + res.match[1] + ' list'

# Stock Functions

	robot.respond /tick (\S*)/i, (msg) ->
		url = 'http://finance.google.com/finance/info?client=ig&q='
		getTicker(url+msg.match[0].toString(), msg)

	robot.respond /stocks/i, (msg) ->
		url = 'https://listophrenic.herokuapp.com/stocks'
		getRest(url, msg)

	robot.respond /addstock (\S*)/i, (msg) ->
		url = 'https://listophrenic.herokuapp.com/post/stocks/' + msg.match[1]
		getRest(url, msg)

	robot.respond /dropstock (\S*)/i, (res) -> 
		stock = res.match[1].toUpperCase()
		if stock in robot.brain.get("stocks")
			res.reply stock + ' has been removed from the stock list'

	robot.respond /ticker/i, (msg) ->
		#url = 'http://finance.google.com/finance/info?client=ig&q='
		#msg.send 'loading stock list'
		#getTicker(url+robot.brain.get("stocks").toString(), msg)
		msg.send 'loading tickers'
		getStocks('https://listophrenic.herokuapp.com/stocks', msg)


# Trolling Functions
	robot.hear /(.*)$/i, (msg) ->
		if msg.message.user.name.toLowerCase() == "nash"
			value = msg.match[1]
			url = 'https://listophrenic.herokuapp.com/post/nash-messages/' + value
			request.get { uri: link }, (err, r, body) -> 
				if Math.random() < 0.015
					msg.reply 'shut up nash'

	robot.respond /nahsh/i, (res) ->
		nash = !nash
		res.reply 'bashing nash is ' + nash

	robot.respond /nashdrop/i, (res) ->
		link = 'https://listophrenic.herokuapp.com/nash-messages'
		request.get { uri: link }, (err, r, body) -> 
			list = body.substring(1,body.length-1).split(",")
			index = Math.floor(Math.random()*list.length)
			res.reply list[index]

	robot.respond /nashlist/i, (res) ->
		rm = res.message.room
		if rm == "molly-log" || rm == "bots"
			list = robot.brain.get('nash-messages')
			res.reply list.toString()

# Molly Functions

	robot.respond /gimme/i, (res) ->
		res.send 'pay me'

	robot.respond /house (\S*)/i, (res) ->
		if res.message.user.name.toLowerCase() == "d"
			houseadv = parseFloat(res.match[1], 10)
			res.send 'house advantage set to: ' + (1-houseadv)
		else
			res.send 'no swiping'

	robot.respond /wealth/i, (res) ->
		robot.brain.set 'potentialBet', 1
		res.send "molly balance"

	robot.respond /wealth (\S*)/i, (res) ->
		robot.brain.set 'potentialBet', res.match[1]

	robot.respond /you have (\S*) kkreds/i, (res) ->
		potBet = parseFloat(robot.brain.get('potentialBet'), 10)
		total = parseFloat(res.match[1], 10)+potBet
		res.send "minimum odds to get paid = " + houseadv*potBet/total

	robot.hear /molly pay viper (\S*) quantum (\S*)/i, (res) ->
		robot.brain.set 'quantumOdds', res.match[2]

	robot.hear /(\S*): Successfully sent (\S*) to viper/i, (res) ->
		user = res.match[1]
		bet = res.match[2]
		seed = Math.random()
		odds = robot.brain.get('quantumOdds')
		quantum = odds > 0 && odds < 1 && bet > 0 && bet <= 3
		if quantum && res.message.user.name.toLowerCase() == "molly"
			if odds > seed
				res.send 'Seed: ' + seed
				res.reply 'pay ' + user + ' ' + houseadv*bet/odds
			else
				res.send 'Seed: ' + seed
				res.send 'viper steals ' + bet + ' kkreds'
		else
			res.send 'Non-quantum parameters specified'