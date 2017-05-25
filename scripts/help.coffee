# Description:
#   it's here
#
# Dependencies:
#   don't know
#
# Configuration:
#   npm
#
# Author:
#	darrencattle

output = '''
m0lly pay viper {bet} quantum {odds} - theoretical dice game, max bet 3, odds between 0-1, payout is 99%
viper draw {cards} - draw # of cards
viper gimme - make viper say pay me for molly, thanks
viper shuffle - shuffle cards
viper wealth {bet} - find viper's balance and minimum required odds, default is 1
	::: LISTOPHRENIC ENABLED :::
viper addstock - add a legitimate stock ticker to the list
viper get {list} - display from list
viper nashdrop - random phrases from nash
viper post {list} {value} - add value to list
viper stocks - current list of stocks
viper tick {AMD} - check a single stock
viper ticker - display current tickers from stock list
''';

module.exports = (robot) ->

#	Help Calls

	robot.respond /help/i, (msg) ->
		msg.send output
