#This file contains classes of different pokecats in the game.

#Machocat Family
class Machocat
	attr_accessor(:name, :lv, :hp, :maxhp, :atk, :def, :speed, :exp, :maxexp, :giveexp, :skill1_name, :skill2_name, :skill3_name, :race) #Allow access to all variables
	def initialize(lv)	#Initialize all variables
		@name = "Macho Cat"
		@lv = lv
		set_stats
		@exp = 10 * @lv * @lv		#Yes, it is easy to level up in this game
		@skill1_name = "Noise"
		@skill2_name = "Muscle Up"
		@skill3_name = "Tyson Punch"
		@race = "Normal"		#As in pokemon, there are different races in pokecat
	end
	
	def skill_message(skill_name)	#This method prints out one line as notification of the skill used
		puts "#{@name} uses #{skill_name}!"
	end
		
	def set_stats		#This method sets the following attributes according to level
		@hp = 350 + 20 * @lv
		@atk = 10 + 10 * @lv
		@def = 4 + 1 * @lv
		@speed = 10
		@maxhp = 350 + 20 * @lv
		@orgatk = 10 + 10 * @lv
		@orgdef = 4 + 1 * @lv
		@orgspeed = 10 
		@maxexp = 10 * @lv * @lv
		@giveexp = 20 * @lv
	end
	
	def calc_exp(given_exp)		#This method calculates the exp the pokecat gets after each battle and whether to level up
		@exp += given_exp		#Add the given exp to the cat's exp
		puts "#{@name} acquires #{given_exp} xp!!"
		for n in 1..10			#I assume that one pokecat can level up maximum 10 times in one battle, which is quite impossible to reach
			if @exp >= @maxexp	#If the exp is higher than the exp limit for current level, then level up
				puts "Congratulations!!! Level up!!!"
				@lv += 1
				sleep 1
				puts "#{@name} is now at Level #{@lv}!!"
				set_stats		#Set the new stats based on the new level
			end
		end
	end
	
	def evolve				#This method determines whether or not to evolve
		@lv >= 10 ? true : false	#If level >= 10 return true, otherwise false
	end
	
	def evolved_form		#This method returns the new form the pokecat evolves into
		return Mohawkcat.new(@lv)
	end
	
	def skill1(obj)			#This method defines skill 1
		skill_message(@skill1_name)
		sleep 1
		puts "Scared by the horrifying noise, the atk of #{obj.name} slightly decreases!"
		obj.atk = obj.atk * 9 / 10
		sleep 1
	end
	
	def skill2(obj)			#This method defines skill 2
		skill_message(@skill2_name)
		sleep 1
		puts "After some supersets of upper body, the atk of #{@name} dramatically increases!"
		@atk = @atk * 2
		sleep 1
	end
	
	def skill3(obj)			#This method defines skill 3
		skill_message(@skill3_name)
		sleep 1
		puts "#{@name} feels like Mike Tyson right now and punches on the head of #{obj.name}!"
		if @atk <= obj.def
			puts "But still, #{obj.name} is too strong in defense. This attack is useless."
		else
			obj.hp = obj.hp + obj.def - @atk
		end
		sleep 1
	end
	
	def print_stats			#This method prints out the stats of this pokecat
		puts @name
		puts "Lv: #{@lv}"
		puts "HP: #{@hp}/#{@maxhp}"
		puts "Attack: #{@atk}"
		puts "Defense: #{@def}"
		puts "Speed: #{@speed}"
	end
	
	def reset_stats			#This method resets the stats of the pokecat back to the original values (excluding hp) after a battle
		@atk = @orgatk
		@def = @orgdef
		@speed = @orgspeed
	end
end

class Mohawkcat < Machocat
	def initialize(lv)
		super
		@name = "Mohawk Cat"
		@skill1_name = "Let's Rap"
		@skill3_name = "New Kung Fu Kenny"
	end
	
	def set_stats
		super
		@hp = 350 + 30 * @lv
		@atk = 10 + 13 * @lv
		@maxhp = 350 + 30 * @lv
		@orgatk = 10 + 12 * @lv
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "As a street gangster, #{@name} learned to rap like Tupac. After hearing its crazy rap, #{obj.name} lost its strength!"
		obj.atk = obj.atk * 3 / 5
		sleep 1
	end
	
	def skill3(obj)
		skill_message(@skill3_name)
		sleep 1
		puts "After evolution, #{@name} no longer admires Mike Tyson. Instead, he has become New Kung Fu Kenny!! #{obj.name} is badly damaged!"
		if @atk <= obj.def
			puts "But still, #{obj.name} is too strong in defense. This attack is useless."
		else
			obj.hp = obj.hp + obj.def - @atk
		end
		sleep 1
	end
	
	def evolve
		@lv >= 15 ? true : false
	end
	
	def evolved_form
		return Killercat.new(@lv)
	end
end

class Killercat < Mohawkcat
	def initialize(lv)
		super
		@name = "Killer Cat"
		@skill1_name = "Murderous Look"
		@skill3_name = "True Assassination"
	end
	
	def set_stats
		super
		@hp = 350 + 40 * @lv
		@atk = 10 + 20 * @lv
		@maxhp = 350 + 40 * @lv
		@orgatk = 10 + 20 * @lv
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "#{@name} gives #{obj.name} a frightening murderous look, #{obj.name} is too scared to use its strength..."
		obj.atk = obj.atk * 2 / 5
		sleep 1
	end
	
	def skill3(obj)
		skill_message(@skill3_name)
		sleep 1
		puts "As an official killer, #{@name} teleports to the back of #{obj.name} and stabs it."
		if @atk <= obj.def
			puts "But still, #{obj.name} is too strong in defense. This attack is useless."
		else
			obj.hp = obj.hp + obj.def - @atk
		end
		sleep 1
	end
	
	def evolve
		false
	end
end

#Tankcat Family
class Tankcat < Machocat
	def initialize(lv)
		super
		@name = "Tank Cat"
		@skill1_name = "Knock"
		@skill2_name = "Harden"
		@skill3_name = "Wall Crash"
	end
	
	def set_stats
		super
		@hp = 650 + 50 * @lv
		@atk = 5 + 5 * @lv
		@def = 9 + 2 * @lv
		@speed = 8
		@maxhp = 650 + 50 * @lv
		@orgatk = 5 + 5 * @lv
		@orgdef = 9 + 2 * @lv
		@orgspeed = 8
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "#{@name} knocks #{obj.name}'s body."
		if @atk <= obj.def
			puts "But #{obj.name} is too strong in defense. This attack is useless."
		else
			obj.hp = obj.hp + obj.def - @atk
		end
		sleep 1
	end
	
	def skill2(obj)
		skill_message(@skill2_name)
		sleep 1
		puts "#{@name} puts some metal powder on its body. The defense of #{@name} slightly increases!"
		@def += 2
		sleep 1
	end
	
	def skill3(obj)
		skill_message(@skill3_name)
		sleep 1
		puts "Suddenly, #{@name} uses its own body to smash #{obj.name} regardless of the defense of the enemy!!"
		obj.hp = obj.hp - @atk - @def * 3
		sleep 1
	end
	
	def evolved_form
		return Wallcat.new(@lv)
	end
end

class Wallcat < Tankcat
	def initialize(lv)
		super
		@name = "Wall Cat"
	end
	
	def set_stats
		super
		@hp = 650 + 55 * @lv
		@atk = 5 + 6 * @lv
		@def = 9 + 3 * @lv
		@maxhp = 650 + 55 * @lv
		@orgatk = 5 + 6 * @lv
		@orgdef = 9 + 3 * @lv
	end
	
	def evolve
		@lv >= 15 ? true : false
	end
	
	def evolved_form
		return Erasercat.new(@lv)
	end
end

class Erasercat < Wallcat
	def initialize(lv)
		super
		@name = "Eraser Cat"
	end
	
	def set_stats
		super
		@hp = 650 + 60 * @lv
		@atk = 5 + 7 * @lv
		@def = 10 + 5 * @lv
		@speed = 10
		@maxhp = 650 + 60 * @lv
		@orgatk = 5 + 7 * @lv
		@orgdef = 10 + 5 * @lv
		@orgspeed = 10
	end
	
	def evolve
		false
	end
end

#Warriorcat Family
class Warriorcat < Machocat
	def initialize(lv)
		super
		@name = "Warrior Cat"
		@skill1_name = "Warrior's Rage"
		@skill2_name = "Bloody Sword"
		@skill3_name = "Ultimate Strike"
	end
	
	def set_stats
		super
		@hp = 300 + 15 * @lv
		@atk = 10 + 15 * @lv
		@def = 7 + 1 * @lv
		@speed = 10
		@maxhp = 300 + 15 * @lv
		@orgatk = 10 + 15 * @lv
		@orgdef = 7 + 1 * @lv
		@orgspeed = 10
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "#{@name} is reminded of the death of its father, so its heart of revenge comes back!! Atk doubles!!"
		@atk = @atk * 2
		sleep 1
	end
	
	def skill2(obj)
		skill_message(@skill2_name)
		sleep 1
		puts "#{@name} cuts itself and lets blood flow around the sword! Atk increases dramatically with the cost of its health!!"
		@atk = @atk + 5 * @lv
		@hp = @hp * 3 / 4
		sleep 1
	end
	
	def skill3(obj)
		skill_message(@skill3_name)
		sleep 1
		puts "The Ultimate Heart of Revenge! Lead Me towards Success!!!!"
		if obj.race == "Water"
			puts "Strong against Water!!"
			obj.hp = obj.hp - @atk * 2
		else
			if @atk <= obj.def
				puts "But still, #{obj.name} is too strong in defense. This attack is useless."
			else
				obj.hp = obj.hp + obj.def - @atk
			end
		end
		sleep 1
	end
	
	def evolved_form
		return Knightcat.new(@lv)
	end
end

class Knightcat < Warriorcat
	def initialize(lv)
		super
		@name = "Knight Cat"
		@skill1_name = "Knight's Rage"
	end
	
	def set_stats
		super
		@hp = 300 + 30 * @lv
		@atk = 15 + 20 * @lv
		@def = 7 + 3 * @lv
		@maxhp = 300 + 30 * @lv
		@orgatk = 15 + 20 * @lv
		@orgdef = 7 + 3 * @lv
	end
	
	def skill2(obj)
		skill_message(@skill2_name)
		sleep 1
		puts "#{@name} cuts itself and lets blood flow around the sword! Atk increases with an incredible cost of its health!!"
		@atk = @atk + 15 * @lv
		@hp = @hp * 2 / 3
		sleep 1
	end
	
	def evolve
		@lv >= 20 ? true : false
	end
	
	def evolved_form
		return Maniccat.new(@lv)
	end
end

class Maniccat < Knightcat
	def initialize(lv)
		super
		@name = "Manic Cat"
		@skill1_name = "Manic Heart"
		@skill2_name = "Bloody Sacrifice"
		@skill3_name = "Dark Strike"
	end
	
	def set_stats
		super
		@hp = 500 + 35 * @lv
		@atk = 50 + 30 * @lv
		@def = 10 + 3 * @lv
		@maxhp = 500 + 35 * @lv
		@orgatk = 50 + 30 * @lv
		@orgdef = 10 + 3 * @lv
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "Overexcited about the slaughter, atk increases, tremendously."
		@atk = @atk * 3
		sleep 1
	end
	
	def skill2(obj)
		skill_message(@skill2_name)
		sleep 1
		puts "#{@name} cuts its own face and uses the scar to raise up its rage."
		@atk = @atk + 20 * @lv
		@hp = @hp * 2 / 3
		sleep 1
	end
	
	def skill3(obj)
		skill_message(@skill3_name)
		sleep 1
		puts "The dark mental aura surrounds #{@name}. In transience, #{@name} jumps into the sky and strikes onto #{obj.name}."
		if obj.race == "Water"
			puts "Strong against Water!!"
			obj.hp = obj.hp - @atk * 2
		else
			obj.hp = obj.hp - @atk
		end
		sleep 1
	end
	
	def evolve
		false
	end
end

#Ufocat Family
class Ufocat < Machocat
	def initialize(lv)
		super
		@name = "UFO Cat"
		@skill1_name = "Light Beam"
		@skill2_name = "Gravitation"
		@skill3_name = "Catastrophe"
		@race = "Float"
	end
	
	def set_stats
		super
		@hp = 250 + 12 * @lv
		@atk = 40 + 17 * @lv
		@def = 5 + 1 * @lv
		@speed = 12
		@maxhp = 250 + 12 * @lv
		@orgatk = 40 + 17 * @lv
		@orgdef = 5 + 1 * @lv
		@orgspeed = 12
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "#{@name} uses the abductive light beam to gently tickle #{obj.name}."
		obj.hp -= 10
		obj.def -= 2
		sleep 1
	end
	
	def skill2(obj)
		skill_message(@skill2_name)
		sleep 1
		puts "#{@name} manipulates its core part to change the gravity of the battle field!! Its speed increases while #{obj.name}'s speed decreases!!"
		@speed += 4
		obj.speed -= 4
		sleep 1
	end
	
	def skill3(obj)
		skill_message(@skill3_name)
		sleep 1
		puts "When #{@name} is about to reach its true form, it will always cause a...... CATASTROPHE!!!"
		n = 0
		if obj.race == "Angel"
			n = 4
		else
			n = 2
		end
		if @atk * n <= obj.def
			puts "But still, #{obj.name} is too strong in defense. This attack is useless."
		else
			obj.hp = obj.hp + obj.def - @atk * n
		end
		sleep 1
	end
	
	def evolved_form
		return Dronecat.new(@lv)
	end
end

class Dronecat < Ufocat
	def initialize(lv)
		super
		@name = "Drone Cat"
	end
	
	def set_stats
		super
		@hp = 400 + 12 * @lv
		@atk = 80 + 17 * @lv
		@def = 9 + 1 * @lv
		@maxhp = 400 + 12 * @lv
		@orgatk = 80 + 17 * @lv
		@orgdef = 9 + 1 * @lv
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "#{@name} uses the abductive light beam to gently tickle #{obj.name}."
		obj.hp -= 20
		obj.def -= 4
		sleep 1
	end
	
	def evolve
		@lv >= 20 ? true : false
	end
	
	def evolved_form
		return Blackhawkcat.new(@lv)
	end
end

class Blackhawkcat < Dronecat
	def initialize(lv)
		super
		@name = "BlackHawk Cat"
	end
	
	def set_stats
		super
		@hp = 600 + 15 * @lv
		@atk = 120 + 20 * @lv
		@def = 12 + 2 * @lv
		@maxhp = 600 + 15 * @lv
		@orgatk = 120 + 20 * @lv
		@orgdef = 12 + 2 * @lv
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "#{@name} uses the abductive light beam to gently tickle #{obj.name}."
		obj.hp -= 80
		obj.def -= 5
		sleep 1
	end
	
	def evolve
		false
	end
end

#Fishcat Family
class Fishcat < Machocat
	def initialize(lv)
		super
		@name = "Fish Cat"
		@skill1_name = "Bite"
		@skill2_name = "Sharpen"
		@skill3_name = "No Discrimination"
		@race = "Water"
	end
	
	def set_stats
		super
		@hp = 550 + 10 * @lv
		@atk = 60 + 30 * @lv
		@def = 0 + 1 * @lv
		@speed = 6
		@maxhp = 550 + 10 * @lv
		@orgatk = 60 + 30 * @lv
		@orgdef = 0 + 1 * @lv
		@orgspeed = 6
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "Cats bite fish, but why can't fish bite cats? "
		if @atk <= obj.def
			puts "But still, #{obj.name} is too strong in defense. This attack is useless."
		else
			obj.hp = obj.hp + obj.def - @atk
		end
		sleep 1
	end
	
	def skill2(obj)
		skill_message(@skill2_name)
		sleep 1
		puts "#{@name} uses a rock to sharpen its teeth (How's that possible??). Atk slightly increases."
		@atk = @atk * 11 / 10
		sleep 1
	end
	
	def skill3(obj)
		skill_message(@skill3_name)
		sleep 1
		puts "Just because it looks like a fish, it does not mean that it should be discriminated!!! For equality, the hp percentage of both cats are now half."
		obj.hp = obj.hp / 2
		@hp = @hp / 2
		sleep 1
	end
	
	def evolved_form
		return Whalecat.new(@lv)
	end
end

class Whalecat < Fishcat
	def initialize(lv)
		super
		@name = "Whale Cat"
	end
	
	def set_stats
		super
		@hp = 750 + 11 * @lv
		@atk = 80 + 35 * @lv
		@maxhp = 750 + 11 * @lv
		@orgatk = 80 + 35 * @lv
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "Now what?! I am a whale! Dare you cats bite me?!"
		if @atk <= obj.def
			puts "But still, #{obj.name} is too strong in defense. This attack is useless."
		else
			obj.hp = obj.hp + obj.def - @atk
		end
		sleep 1
	end
	
	def evolve
		@lv >= 20 ? true : false
	end
	
	def evolved_form
		return Islandcat.new(@lv)
	end
end

class Islandcat < Machocat
	def initialize(lv)
		super
		@name = "Island Cat"
		@skill1_name = "Island Drift"
		@skill2_name = "Sea Level Rise"
		@skill3_name = "Earthquake"
		@race = "Water"
	end
	
	def set_stats
		super
		@hp = 1000 + 12 * @lv
		@atk = 100 + 36 * @lv
		@maxhp = 1000 + 12 * @lv
		@orgatk = 100 + 36 * @lv
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "#{@name} drifts towards #{obj.name}."
		if obj.race == "Normal"
			puts "Strong against Normal!!"
			obj.hp = obj.hp - @atk * 2
		else
			if @atk <= obj.def
				puts "But still, #{obj.name} is too strong in defense. This attack is useless."
			else
				obj.hp = obj.hp + obj.def - @atk
			end
		end
		sleep 1
	end
	
	def skill2(obj)
		skill_message(@skill2_name)
		sleep 1
		puts "As sea level rises, #{@name} becomes more flexible. Atk and speed increases."
		@atk = @atk * 6 / 5
		@speed += 2
		sleep 1
	end
	
	def skill3(obj)
		skill_message(@skill3_name)
		sleep 1
		puts "#{@name} shakes its body and creates an earthquake!! "
		if obj.race == "Float"
			puts "But the floating creatures are unaffected."
		else
			obj.hp = obj.hp - @atk * 4
		end
		@hp = @hp * 3 / 4
		sleep 1
	end
	
	def evolve
		false
	end
end

#Amon's Cat
class Mightycatalord < Machocat
	def initialize(lv)
		super
		@name = "Mighty Catalord"
		@skill1_name = "Tail Smash"
		@skill2_name = "Doomsday"
		@skill3_name = "Core power"
		@race = "Mythical"
	end
	
	def set_stats
		super
		@hp = 1000 * @lv
		@atk = 100 * @lv
		@def = 10 * @lv
		@speed = 25
		@maxhp = 1000 * @lv
		@orgatk = 100 * @lv
		@orgdef = 10 * @lv
		@orgspeed = 25
	end
	
	def skill1(obj)
		skill_message(@skill1_name)
		sleep 1
		puts "Catalord concentrates the soul energy onto the tail and smashes #{obj.name} with it."
		obj.hp -= @atk
		sleep 1
	end
	
	def skill2(obj)
		skill_message(@skill2_name)
		sleep 1
		puts "Catalord annouces the doomsday for #{obj.name}, which is TODAY!!! All attributes of #{obj.name} decrease!!!"
		obj.atk = obj.atk / 4
		obj.def = obj.def / 4
		obj.speed = obj.speed / 2
	end
	
	def skill3(obj)
		skill_message(@skill3_name)
		sleep 1
		puts "Catalord is kind enough to show its core power to #{obj.name} before its death. If #{obj.name} is lucky, it can still survive. If not, RIP."
		chance = rand(10)
		sleep 1
		if chance == 0
			puts "Fortunately, #{obj.name} survives."
		else
			puts "Unfortunately, RIP, #{obj.name}."
			obj.hp = 0
		end
		sleep 1
	end
end