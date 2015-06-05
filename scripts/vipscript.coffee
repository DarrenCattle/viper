# Description:
#   Viper the bot useful scripts
#
# Commands:
#   viper have some crack - feed viper his essentials
#   viper sleep it off - help viper maintain balance in life
#   viper wassup (with that) - you already know
#	viper quantum {bet} {percentage} - theoretical dice game, max bet 10, odds between 0-1, payout is bet/percentage

module.exports = (robot) ->

	robot.respond /have some crack/i, (res) ->
		# Get number of crack had (coerced to a number).
		crackHad = robot.brain.get('totalCrack') * 1 or 0

		if crackHad > 4
			res.reply "I'm cracked out..."

		else
			robot.brain.set 'totalCrack', crackHad+1
			res.reply 'I love crack!'
			res.reply robot.brain.get('totalCrack')

	robot.respond /sleep it off/i, (res) ->
		robot.brain.set 'totalCrack', 0
		res.reply 'zzzzz'

	robot.respond /wassup/i, (res) ->
		res.reply "ya'll cowards don't even smoke crack"

	robot.respond /quantum (\S*) (\S*)/i, (res) ->
    	bet = res.match[1]
    	odds = res.match[2]
    	seed = Math.random()
    	quantum = odds > 0 && odds < 1 && bet > 0 && bet <= 10

    	if quantum
    		if odds > seed
    			res.reply 'Seed: ' + seed
    			res.reply bet/odds + ' kkreds earned!'
   			else
   				res.reply 'Seed: ' + seed
    			res.reply 'viper snorts ' + bet + ' krack kreds'
    	else
    		res.reply 'Non-quantum parameters specified'



