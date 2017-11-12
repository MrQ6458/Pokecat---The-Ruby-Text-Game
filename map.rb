#This file contains classes of different places in the game.

#Require access to the necessary header files
require_relative 'characters'
require_relative 'player'
class Place		#Define the general Place class that contains all necessary methods for different places
	attr_accessor(:name)	#Allow access to "name" variable
	def initialize
		@name = ""				#Initialize "name" variable
		@enemies = Array.new	#Initialize "enemies" array
		@able_to_gacha = true	##Initialize a boolean variable determining whether or not the enemy pokecat is allowed to be captured. You cannot capture the pokecats owned by other trainers.
	end
	
	def space	#This method prints space between different lines
		puts ""
	end
	
	def your_turn(obj, opp, is_battle, player)	#This method defines the player's turn in a battle
		if obj.hp > 0		#Check if the player's pokecat on the field can battle
			sleep 1
			puts "What should #{obj.name} do?!"		#Prompt which skill the pokecat should use
			puts "a. #{obj.skill1_name}"
			puts "b. #{obj.skill2_name}"
			puts "c. #{obj.skill3_name}"
			choice = gets.chomp
			case choice						#Apply the chosen skill to the enemy
			when "a" then obj.skill1(opp)
			when "b" then obj.skill2(opp)
			when "c" then obj.skill3(opp)
			end
			space
			sleep 1
			if opp.hp <= 0					#If the enemy dies, Mr.Q wins
				puts "#{opp.name} falls down. Mr.Q wins!!!"
				sleep 1
				obj.calc_exp(opp.giveexp)	#The pokecat is awarded with exp
				if obj.evolve				#If the pokecat reaches a certain level at which it can evolve, it evolves
					puts "Wait... Something is happening to #{obj.name}..."
					lv = obj.lv
					new_obj = obj.evolved_form		#The pokecat changes into the evolved form of it.
					player.poke[0] = new_obj
					3.times do 
						sleep 1
						puts "."
					end
					puts "Congratulations!! #{obj.name} evolves into #{new_obj.name}!!"
				end
				is_battle = false		#Quit the battle
			end
			sleep 1
			is_battle
		else
			is_battle = false
		end
		is_battle		#Return the boolean that determines whether or not the battle is still going
	end
	
	def enemy_turn(obj, opp, is_battle, player)		#This method defines the enemy's turn in a battle
		if opp.hp > 0		#Check if the enemy can battle
			obj.print_stats	#Print out stats for both sides so that the player has a clear view of the situation
			space
			opp.print_stats
			sleep 2
			chance = rand(3)	#Which skill the enemy uses is determined by chance. Yeah sorry I can't build AI yet.
			case chance
			when 0 then opp.skill1(obj)
			when 1 then opp.skill2(obj)
			when 2 then opp.skill3(obj)
			end
			space
			sleep 1
			if obj.hp <= 0		#If the player's pokecat dies
				obj.hp = 0
				obj.reset_stats		#Reset the changed stats (excluding hp) back to the original values
				puts "#{obj.name} lost too much blood. Mr.Q needs to choose another pokecat!"
				n_alivecats = 0		#Initialize the number of pokecats that are still able to battle in poke array
				player.poke.each do |x|		#Iterate through poke array
					if x.hp > 0			#Count the number of pokecats alive
						n_alivecats += 1
					end
				end
				if n_alivecats != 0		#If the number is not 0, then put one of the alive cats in the first position
					player.change_first_pokecat
					is_battle = true
				else					#Else, go to pc and revive them
					puts "No!!!! Mr.Q has no pokecat that can still battle! Mr.Q needs to go to PC!!!"
					is_battle = false
				end
			end
		end
		sleep 1
		is_battle
	end
	
	def pc(player)		#This method defines the pc curing
		puts "Gorgeous Nurse: Hello handsome boy! Let me help you cure your lovely pokecats!!!"
		sleep 1
		player.poke.each {|x| x.hp = x.maxhp}	#Cure all pokecats in poke array
		3.times do
			puts "."
			sleep 1
		end
		puts "Gorgeous Nurse: Yeah!! Now your lovely pokecats are energetic and ready to fight!"
		sleep 2
		puts "Gorgeous Nurse: (air kiss) Bye!!! Have a wonderful day!!!"
		sleep 2
		puts "Mr.Q: (I feel like I am in love...)"
		sleep 1
		space
	end
	
	def shop(player)		#This method defines the consumption of goods in a shop
		puts "What would Mr.Q like to buy?"		#Prompt for the item the player wants to buy
		puts "a. Cataball -- $100"
		puts "b. Catamin  -- $100"
		choice = gets.chomp
		puts "Cashier: How many?"	#Prompt for the number of items
		n = gets.chomp.to_i
		money = player.money		#Read the pocket money the player has
		if money < 100 * n		#If the money is not enough, GET OUT!!!
			puts "Cashier: You poor lil boy get outta my shop!!!"
		else			#If enough, put the items into the items array and reduce the pocket money
			case choice
			when "a" then n.times {player.items << Cataball.new}
			when "b" then n.times {player.items << Catamin.new}
			end
			player.money = money - 100 * n
			sleep 1
			puts "Cashier: Thanks Bro! Please come again!"
		end
		space
	end
	
	def battle(player)		#This method defines a battle
		opp = @enemies[rand(@enemies.length)]	#Read the enemy object
		puts "#{opp.name} shows up!!!"
		sleep 1
		is_battle = true	#This boolean determines whether or not the fight keeps going
		while is_battle		#Loop the battle
			obj = player.poke[0]	#The first position in the poke array always shows up first on the battle field
			obj.print_stats
			space
			opp.print_stats
			space
			sleep 2
			puts "What should Mr.Q do?!"	#Prompt for what the player should do
			puts "a. Fight"
			puts "b. Backpack"
			puts "c. Pokecats"
			puts "d. Run Away"
			choice = gets.chomp
			case choice
			when "a"	#Start fighting directly
				if obj.speed < opp.speed	#The faster one attacks first
					is_battle = enemy_turn(obj, opp, is_battle, player)
					is_battle = your_turn(obj, opp, is_battle, player)
				else
					is_battle = your_turn(obj, opp, is_battle, player)
					is_battle = enemy_turn(obj, opp, is_battle, player)
				end
				if is_battle == false	#If the fight is over, reset the changed stats (hp included for enemy but excluded for the player's cat) back to the original values
					opp.reset_stats
					opp.hp = opp.maxhp
					obj.reset_stats
				end
			when "b"	#Use items from items array
				cata_ball = Cataball.new		#Define new cataball and catamin
				cata_min = Catamin.new
				n_cataball, n_catamin = player.check_items		#Get the number of items
				puts "Which item would Mr.Q use?"	#Prompt for which item to use
				choice = gets.chomp
				case choice
				when "a"		#Use a cataball
					if @able_to_gacha	#If it is allowed to capture the enemy cat
						if n_cataball != 0		#If the player has cataball
							n_cataball -= 1		#The player throws one towards the enemy cat
							gacha = cata_ball.gacha(opp, player)	#See if the capture is successful
							if gacha		#If captured, quit battle
								obj.reset_stats
								is_battle = false
							else			#If not, the enemy can still attack you
								enemy_turn(obj, opp, is_battle, player)
							end
						else		#If the player has no balls, then nahh
							puts "Mr.Q does not have Cataballs."
						end
					else			#If it is not allowed to capture the enemy cat, then nahh
						puts "Mr.Q cannot use this item here."
					end
				when "b" 		#Use a catamin
					if n_catamin != 0	#If the player has catamin
						n_catamin -= 1	#One catamin is used
						cata_min.cure(player)	#Cure one cat
						enemy_turn(obj, opp, is_battle, player)		#But the enemy still gets to attack
					else				#If the player has no catamin, then nahh
						puts "Mr.Q does not have Catamins."
					end
				end
				player.items.clear	#Clear the items array
				n_cataball.times {player.items << Cataball.new}	#Put new numbers of items into the array
				n_catamin.times {player.items << Catamin.new}
				sleep 1
			when "c" then player.change_first_pokecat	#Swap pokecats
			when "d"		#Run away!!!!
				if @able_to_gacha == false		#If you are fighting with a trainer, you cannot run away
					puts "Mr.Q cannot run away like a coward!!"
					sleep 1
				else
					obj.reset_stats
					opp.reset_stats
					opp.hp = opp.maxhp
					break
				end
			end
		end
	end
	
	def inquiry(player)		#This method prompts for player's choice in the place
		puts "What should Mr.Q do here?"
		puts "a. PC"
		puts "b. Shop"
		puts "c. Swap Pokecat Slot"
		puts "d. Check Items"
		puts "e. Check Pokecats"
		puts "f. Fight Wild Pokecats"
		choice = gets.chomp.downcase
		case choice		#Different functions are invoked for different choices
		when "a" then pc(player)
		when "b" then shop(player)
		when "c" then player.change_first_pokecat
		when "d" then player.check_items
		when "e" then player.check_pokecats
		when "f" then battle(player)
		end
	end
end
	
class Ingsocity < Place		#Ingsocity class inherits from Place class
	def initialize
		super
		@name = "Ingsoc City"
		@able_to_gacha = false
	end
	
	def inquiry(player)		#Inquiry method is modified for this specific place
		puts "What should Mr.Q do here?"
		puts "a. PC"
		puts "b. Shop"
		puts "c. Swap Pokecat Slot"
		puts "d. Check Items"
		puts "e. Check Pokecats"
		choice = gets.chomp.downcase
		case choice
		when "a" then pc(player)
		when "b" then shop(player)
		when "c" then player.change_first_pokecat
		when "d" then player.check_items
		when "e" then player.check_pokecats
		end
	end
end

class Chinatown < Ingsocity		#Chinatown class inherits from Ingsocity class
	def initialize
		super
		@name = "China Town"
	end
	
	def mom_talk		#Story
		puts "Mr.Q: Hey Mom I am back!"
		sleep 2
		puts "Mom: Why are you back?! Stop wasting your life! Go out and make friends!"
		sleep 2
		puts "Mr.Q is driven out of his house."
		sleep 2
		space
	end
	
	def doctor_talk		#Story
		puts "Mr.Q: Hey Doctor I am back!"
		sleep 2
		puts "Doctor: Do you not know my name?"
		sleep 2
		puts "Mr.Q: ......"
		sleep 2
		puts "Doctor: My name is"
		sleep 2
		puts "Doctor: Hey what is my name..."
		sleep 2
		space
	end
	
	def inquiry(player)
		puts "What should Mr.Q do here?"
		puts "a. PC"
		puts "b. Shop"
		puts "c. Swap Pokecat Slot"
		puts "d. Check Items"
		puts "e. Check Pokecats"
		puts "f. Talk to Mom"
		puts "g. Talk to Doctor"
		puts "h. Save Progress"
		choice = gets.chomp.downcase
		case choice
		when "a" then pc(player)
		when "b" then shop(player)
		when "c" then player.change_first_pokecat
		when "d" then player.check_items
		when "e" then player.check_pokecats
		when "f" then mom_talk
		when "g" then doctor_talk
		when "h" then player.save
		end
	end
end

class Roadofchampion < Ingsocity		#Roadofchampion class inherits from Ingsocity class
	def initialize
		super
		@name = "Road of Champion"
		@enemies = [Knightcat.new(18), Knightcat.new(19), Whalecat.new(18), Whalecat.new(19), Dronecat.new(18), Dronecat.new(19)]
	end
	
	def inquiry(player)
		puts "What should Mr.Q do here?"
		puts "a. PC"
		puts "b. Shop"
		puts "c. Swap Pokecat Slot"
		puts "d. Check Items"
		puts "e. Check Pokecats"
		puts "f. Train Pokecats"
		choice = gets.chomp.downcase
		case choice
		when "a" then pc(player)
		when "b" then shop(player)
		when "c" then player.change_first_pokecat
		when "d" then player.check_items
		when "e" then player.check_pokecats
		when "f" then battle(player)
		end
	end
end

class Catagrass < Place		#Catagrass class inherits from Place class
	def initialize
		super
		@name = "Catagrass"
		@enemies = [Warriorcat.new(6), Tankcat.new(6), Ufocat.new(6), Fishcat.new(6)]
	end
	
	def inquiry(player)
		puts "What should Mr.Q do here?"
		puts "a. Swap Pokecat Slot"
		puts "b. Check Items"
		puts "c. Check Pokecats"
		puts "d. Walk Into the Wild Grassfield"
		choice = gets.chomp.downcase
		case choice
		when "a" then player.change_first_pokecat
		when "b" then player.check_items
		when "c" then player.check_pokecats
		when "d" then battle(player)
		end
	end
end

class Catalake < Place		#Catalake class inherits from Place class
	def initialize
		super
		@name = "Catalake"
		# Finish Characters, then come here.
		@enemies = [Warriorcat.new(3), Warriorcat.new(4), Tankcat.new(3), Tankcat.new(4)]
	end
	
	def inquiry(player)
		puts "What should Mr.Q do here?"
		puts "a. Swap Pokecat Slot"
		puts "b. Check Items"
		puts "c. Check Pokecats"
		puts "d. Fishing"
		choice = gets.chomp.downcase
		case choice
		when "a" then player.change_first_pokecat
		when "b" then player.check_items
		when "c" then player.check_pokecats
		when "d" then battle(player)
		end
	end
end

class Cataforest < Place	#Cataforest class inherits from Place class
	def initialize
		super
		@name = "Cataforest"
		@enemies = [Knightcat.new(11), Knightcat.new(12), Wallcat.new(11), Wallcat.new(12)]
	end
	
	def inquiry(player)
		puts "What should Mr.Q do here?"
		puts "a. Swap Pokecat Slot"
		puts "b. Check Items"
		puts "c. Check Pokecats"
		puts "d. Walk Into the Dark Forest"
		choice = gets.chomp.downcase
		case choice
		when "a" then player.change_first_pokecat
		when "b" then player.check_items
		when "c" then player.check_pokecats
		when "d" then battle(player)
		end
	end
end

class Catacave < Place		#Catacave class inherits from Place class
	def initialize
		super
		@name = "Catacave"
		# Finish Characters, then come here.
		@enemies = [Whalecat.new(13), Whalecat.new(14), Dronecat.new(13), Dronecat.new(14)]
	end
	
	def inquiry(player)
		puts "What should Mr.Q do here?"
		puts "a. Swap Pokecat Slot"
		puts "b. Check Items"
		puts "c. Check Pokecats"
		puts "d. Discover Pokecats"
		choice = gets.chomp.downcase
		case choice
		when "a" then player.change_first_pokecat
		when "b" then player.check_items
		when "c" then player.check_pokecats
		when "d" then battle(player)
		end
	end
end

class Treasureisland < Place	#Treasureisland class inherits from Place class
	def initialize
		super
		@name = "Treasure Island"
	end
	
	def inquiry(player)
		puts "This area is not created yet. Bye."
		sleep 1
	end
end

class Amon < Ingsocity		#Amon class inherits from Ingsocity class
	attr_accessor(:name, :enemies)
	def initialize
		super
		@name = "Unholy Paradise"
		@enemies = [Mightycatalord.new(20)]
		@able_to_gacha = false
	end
	
	def inquiry(player)
		puts "Finally, Mr.Q meets the strongest boss in the entire world."
		sleep 2
		puts "Amon!!!"
		sleep 2
		puts "Amon: Well well well, you think that you can beat me?"
		sleep 2
		puts "Amon: Like all the other pokecat trainers do?"
		sleep 2
		puts "Amon: Well, they are all killed. By me."
		sleep 2
		puts "Amon: If you wonder who gives me this, invincible strength."
		sleep 2
		puts "Amon: It is that doctor who suffers amnesia right now!"
		sleep 2
		puts "Amon: I was one of his students. Due to the appealing power of one pokecat that he had, "
		sleep 2
		puts "Amon: I stole it and used it to kill all the students."
		sleep 2
		puts "Amon: Because I was too powerful, I started to hunt and kill other pokecat trainers in the world."
		sleep 2
		puts "Amon: The doctor got angry. He used all possible pokecats and tried his very best to stop me."
		sleep 2
		puts "Amon: But obviously, no pokecat can kill mine."
		sleep 2
		puts "Mr.Q: (snoring)zzzzzzzzz"
		sleep 2
		puts "Amon: WHY ARE YOU SLEEPING!!! SUCH DISRESPECT!!! I NEED TO DESTROY YOU!!!"
		sleep 2
		puts "Mr.Q: (opens eyes) Umm..... oh hey whats up bro. My name is Stokes Qu, aka Mr.Q."
		sleep 2
		puts "(A scary pokecat charges towards Mr.Q) Mr.Q: Hey chill man I just wanna escape the game."
		sleep 2
		puts "Amon: TOO LATE!!!!"
		sleep 2
		puts "Mr.Q: Umm... okay... I mean... I don't know what's going on..."
		sleep 2
		puts "Mr.Q: I'm soooo bored of this game... This game is soooo meaningless... "
		sleep 2
		puts "Mr.Q: I got to know that you are the boss, so I just wanna ask you how I can escape the game,"
		sleep 2
		puts "Mr.Q: since you are the strongest guy in this world. Please help me man I will pay you."
		sleep 2
		puts "Amon: TOO LATE!!!!"
		sleep 2
		puts "Mr.Q: Hey here, here is all my money. Take it and teleport me back to the real world..."
		sleep 2
		puts "Amon: TOO LATE!!!!"
		sleep 2
		puts "Mr.Q: CAN YOU PLEASE LISTEN TO WHAT I AM SAYING!!!"
		sleep 2
		battle(player)
	end
end