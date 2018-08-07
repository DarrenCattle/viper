# Description:
#   it's here
#
# Dependencies:
#   don't know
#
# Configuration:
#   npm
#
# Commands:
#	viper draw {cards} - draw # of cards
#	viper shuffle - new deck of cards default 52
#
# Author:
#	darrencattle

deck = ['A:spades:', 'K:spades:', 'Q:spades:', 'J:spades:', '10:spades:', '9:spades:', '8:spades:', '7:spades:', '6:spades:', '5:spades:', '4:spades:', '3:spades:', '2:spades:', 'A:hearts:', 'K:hearts:', 'Q:hearts:', 'J:hearts:', '10:hearts:', '9:hearts:', '8:hearts:', '7:hearts:', '6:hearts:', '5:hearts:', '4:hearts:', '3:hearts:', '2:hearts:', 'A:clubs:', 'K:clubs:', 'Q:clubs:', 'J:clubs:', '10:clubs:', '9:clubs:', '8:clubs:', '7:clubs:', '6:clubs:', '5:clubs:', '4:clubs:', '3:clubs:', '2:clubs:', 'A:diamonds:', 'K:diamonds:', 'Q:diamonds:', 'J:diamonds:', '10:diamonds:', '9:diamonds:', '8:diamonds:', '7:diamonds:', '6:diamonds:', '5:diamonds:', '4:diamonds:', '3:diamonds:', '2:diamonds:']

playdeck = deck.slice(0)
drawdeck = []

draw = (seeder) ->
	drawdeck.push(playdeck[seeder])
	playdeck.splice(seeder,1)
	return drawdeck[drawdeck.length-1]

module.exports = (robot) ->

#	Card Calls

	robot.respond /draw (\S*)/i, (res) ->
		cards = res.match[1]
		stringer = ''
    if cards < 52
      res.reply '@tom pls nooo'
		else if cards > 0
			stringer += draw(Math.floor(Math.random()*playdeck.length)) + ' ' for [1..cards]
			res.reply stringer
			res.reply 'cards left in deck: ' + playdeck.length
		else
			res.reply 'no cards left in deck'

	robot.respond /shuffle/i, (res) ->
		playdeck = deck.slice(0)
		drawdeck = []
		res.send 'cards left in deck: ' + playdeck.length

#	Misc Items
