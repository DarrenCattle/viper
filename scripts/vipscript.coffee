# Description:
#   Viper the bot useful scripts
#
# Commands:
#   viper have some crack - feed viper his essentials
#   viper sleep it off - help viper maintain balance in life
#   viper wassup (with that) - you already know
#	molly pay viper {bet} quantum {odds} - theoretical dice game, max bet 3, odds between 0-1, payout is 99%
#	viper wealth {bet} - find viper's balance and minimum required odds, default is 1
#	viper gimme - make viper say pay me for molly, thanks
#	viper draw {cards} - draw # of cards
#	viper shuffle - shuffle cards
#	viper blackjack - actually does nothing
#	viper join - joins blackjack game
#	viper deal - stops ability to join and deals 2 cards to every player that joined, deals viper out until end
#	viper hit me - draw 1 more card in blackjack
#	viper stay - change your status to finished, once all players are finished then the winner will be decided and game will be reset and open to join

Decimal = require "decimal.js"

deck = ['A:spades:', 'K:spades:', 'Q:spades:', 'J:spades:', '10:spades:', '9:spades:', '8:spades:', '7:spades:', '6:spades:', '5:spades:', '4:spades:', '3:spades:', '2:spades:', 'A:hearts:', 'K:hearts:', 'Q:hearts:', 'J:hearts:', '10:hearts:', '9:hearts:', '8:hearts:', '7:hearts:', '6:hearts:', '5:hearts:', '4:hearts:', '3:hearts:', '2:hearts:', 'A:clubs:', 'K:clubs:', 'Q:clubs:', 'J:clubs:', '10:clubs:', '9:clubs:', '8:clubs:', '7:clubs:', '6:clubs:', '5:clubs:', '4:clubs:', '3:clubs:', '2:clubs:', 'A:diamonds:', 'K:diamonds:', 'Q:diamonds:', 'J:diamonds:', '10:diamonds:', '9:diamonds:', '8:diamonds:', '7:diamonds:', '6:diamonds:', '5:diamonds:', '4:diamonds:', '3:diamonds:', '2:diamonds:']

playdeck = deck.slice(0)
drawdeck = []
houseadv = 0.9
blackjack_start = false
blackjack_players = {}

viperdraw = (seeder) ->
	drawdeck.push(playdeck[seeder])
	playdeck.splice(seeder,1)
	return drawdeck[drawdeck.length-1]

blackValue = (card) ->
	if card.indexOf('A') > -1
		return 11
	if card.indexOf('K') > -1
		return 10
	if card.indexOf('Q') > -1
		return 10
	if card.indexOf('J') > -1
		return 10
	if card.indexOf('10') > -1
		return 10
	if card.indexOf('9') > -1
		return 9
	if card.indexOf('8') > -1
		return 8
	if card.indexOf('7') > -1
		return 7
	if card.indexOf('6') > -1
		return 6
	if card.indexOf('5') > -1
		return 5
	if card.indexOf('4') > -1
		return 4
	if card.indexOf('3') > -1
		return 3
	if card.indexOf('2') > -1
		return 2

module.exports = (robot) ->

	robot.respond /PING$/i, (msg) ->
    	msg.send "PONG"

  	robot.respond /ADAPTER$/i, (msg) ->
    	msg.send robot.adapterName

  	robot.respond /TIME$/i, (msg) ->
    	msg.send "Server time is: #{new Date()}"

	robot.respond /ECHO (.*)$/i, (res) ->
    if res.message.user.name.toLowerCase() == "d"
        echo = res.match[1]
        res.send echo
    else
        res.reply "ya'll cowards don't even smoke crack"

	robot.respond /draw (\S*)/i, (res) ->
		cards = res.match[1]
		stringer = ''
		if cards > 0 
			stringer += viperdraw(Math.floor(Math.random()*playdeck.length)) + ' ' for [1..cards]
			res.reply stringer
			res.reply 'crack cards left in deck: ' + playdeck.length
		else
			res.reply 'you on crack of :spades: nigga'

	robot.respond /house (\S*)/i, (res) ->
		if res.message.user.name.toLowerCase() == "d"
			houseadv = parseFloat(res.match[1], 10)
			res.send 'house advantage set to: ' + (1-houseadv)
		else
			res.send 'no swiping'

	robot.respond /shuffle/i, (res) ->
		playdeck = deck.slice(0)
		drawdeck = []
		res.send 'cards be like :spades::diamonds::clubs::hearts:'

	robot.respond /have some crack/i, (res) ->
		# Get number of crack had (coerced to a number).
		crackHad = robot.brain.get('totalCrack') * 1 or 0

		if crackHad > 4
			res.send "I'm cracked out..."

		else
			robot.brain.set 'totalCrack', crackHad+1
			res.send 'I love crack! Crack injected: ' + robot.brain.get('totalCrack')

	robot.respond /gimme/i, (res) ->
		res.send 'pay me'

	robot.respond /sleep it off/i, (res) ->
		robot.brain.set 'totalCrack', 0
		res.send 'zzzzz'

	robot.respond /wassup/i, (res) ->
		res.send "ya'll cowards don't even smoke crack"

	robot.respond /wealth/i, (res) ->
		robot.brain.set 'potentialBet', 1
		res.send "molly balance"

	robot.respond /wealth (\S*)/i, (res) ->
		robot.brain.set 'potentialBet', res.match[1]

	robot.respond /you have (\S*) kkreds/i, (res) ->
		potBet = parseFloat(robot.brain.get('potentialBet'), 10)
		total = parseFloat(res.match[1], 10)+potBet
		res.send "minimum odds to get paid = " + houseadv*potBet/total

	robot.hear /molly pay viper (\S*) blackjack (\S*)/i, (res) ->
		robot.brain.set 'quantumOdds', res.match[2]

	robot.hear /(\S*): Successfully sent (\S*) to viper/i, (res) ->
		res.send 'thanks for money'

	robot.respond /blackjack/i, (res) ->
		res.send 'who wants to play blackjack? type (viper join)'

	robot.respond /join/i, (res) ->
		if !blackjack_start
			name = res.message.user.name.toLowerCase()
			if blackjack_players[name]?
				res.send name + ' already joined'
			else
				blackjack_players[name]={	
											person: name
											score: 0
											finished: false
										}
				res.send name + ' has joined'

	robot.respond /deal/i, (res) ->
		res.send 'viper shuffle'
		blackjack_start = true
		for k,player of blackjack_players
			res.send player.person

			stringer = viperdraw(Math.floor(Math.random()*playdeck.length))
			player.score+=blackValue(stringer)
			res.send stringer

			stringer = viperdraw(Math.floor(Math.random()*playdeck.length))
			player.score+=blackValue(stringer)
			res.send stringer

			res.send 'score value: ' + player.score

		blackjack_players["viper"]= {	
										person: "viper"
										score: 0
										finished: false
									}
		res.send 'drawing and finishing viper hand'
		while blackjack_players["viper"].score < 17
			stringer = viperdraw(Math.floor(Math.random()*playdeck.length))
			blackjack_players["viper"].score+=blackValue(stringer)
			res.send stringer
		if blackjack_players["viper"].score > 21
			res.send 'viper busted lol ' + blackjack_players["viper"].score
		else
			res.send 'viper score: ' + blackjack_players["viper"].score
		blackjack_players["viper"].finished = true

		res.send 'initial draw phase complete'

	robot.respond /hit me/i, (res) ->
		name = res.message.user.name.toLowerCase()
		stringer = viperdraw(Math.floor(Math.random()*playdeck.length))
		res.reply stringer
		blackjack_players[name].score+=blackValue(stringer)
		if blackjack_players[name].score > 21
			res.reply 'busted with ' + blackjack_players[name].score
			blackjack_players[name].finished = true
		else
			res.reply 'score value: ' + blackjack_players[name].score


	robot.respond /stay/i, (res) ->
		name = res.message.user.name.toLowerCase()
		blackjack_players[name].finished = true
		res.reply 'final score value: ' + blackjack_players[name].score 
		end = true
		for k,player of blackjack_players
			if !player.finished
				end = false
		if end
			winner = 0
			winnername = ''
			for k,player of blackjack_players
				if player.score > winner && player.score < 22
					winner = player.score
					winnername = player.person
			res.send 'winner is: ' + winnername + ' with ' + winner
			blackjack_players = []
			blackjack_start = false
