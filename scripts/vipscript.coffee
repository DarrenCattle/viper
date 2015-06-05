# Description:
#   Viper the bot useful scripts
#
# Commands:
#   viper have some crack - feed viper his essentials
#   viper sleep it off - help viper maintain balance in life
#   viper wassup (with that) - you already know
#	viper quantum {bet} {percentage} - theoretical dice game, max bet 10, odds between 0-1, payout is bet/percentage

module.exports = (robot) ->

	robot.respond /ECHO (.*)$/i, (res) ->
    if res.message.user.name.toLowerCase() == "d"
        echo = res.match[1]
        res.send echo
    else
        res.reply "ya'll cowards don't even smoke crack"

	robot.hear /have some crack/i, (res) ->
		# Get number of crack had (coerced to a number).
		crackHad = robot.brain.get('totalCrack') * 1 or 0

		if crackHad > 4
			res.reply "I'm cracked out..."

		else
			robot.brain.set 'totalCrack', crackHad+1
			res.reply 'I love crack! Crack injected: ' + robot.brain.get('totalCrack')

	robot.hear /sleep it off/i, (res) ->
		robot.brain.set 'totalCrack', 0
		res.reply 'zzzzz'

	robot.hear /wassup/i, (res) ->
		res.reply "ya'll cowards don't even smoke crack"

	robot.hear /molly pay (\S*) (\S*) quantum (\S*)/i, (res) ->
    	robot.brain.set 'quantumOdds', res.match[3]

	robot.hear /(\S*): Successfully sent (\S*) to viper/i (res) ->
	    user = res.match[1]
	    bet = res.match[2]
	    seed = Math.random()
	    odds = robot.brain.get('quantumOdds')
	    quantum = odds > 0 && odds < 1 && bet > 0 && bet <= 1
	    if quantum && res.message.user.name.toLowerCase() == "molly"
	        if odds > seed
	            res.reply 'Seed: ' + seed                
	            res.reply 'pay ' + user + bet/odds
	        else
	            res.reply 'Seed: ' + seed
	            res.reply 'viper snorts ' + bet + ' krack kreds'
	    else
	        res.reply 'Non-quantum parameters specified'




