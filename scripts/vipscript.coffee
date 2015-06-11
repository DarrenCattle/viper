# Description:
#   Viper the bot useful scripts
#
# Commands:
#   viper have some crack - feed viper his essentials
#   viper sleep it off - help viper maintain balance in life
#   viper wassup (with that) - you already know
#	molly pay viper {bet} quantum {odds} - theoretical dice game, max bet 2, odds between 0-1, payout is 99%
#	viper wealth {bet} - find viper's balance and minimum required odds, default is 1
#	viper gimme - make viper say pay me for molly, thanks

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
		res.send "minimum odds to get paid = " + potBet/total

	robot.hear /molly pay viper (\S*) quantum (\S*)/i, (res) ->
		robot.brain.set 'quantumOdds', res.match[2]

	robot.hear /(\S*): Successfully sent (\S*) to viper/i, (res) ->
		user = res.match[1]
		bet = res.match[2]
		seed = Math.random()
		odds = robot.brain.get('quantumOdds')
		quantum = odds > 0 && odds < 1 && bet > 0 && bet <= 2
		if quantum && res.message.user.name.toLowerCase() == "molly"
			if odds > seed
				res.send 'Seed: ' + seed                
				res.reply 'pay ' + user + ' ' + 0.99*bet/odds
			else
				res.send 'Seed: ' + seed
				res.send 'viper snorts ' + bet + ' krack kreds'
		else
			res.send 'Non-quantum parameters specified'