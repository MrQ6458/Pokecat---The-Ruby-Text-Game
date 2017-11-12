#This file contains the Player class and classes of items needed for the game.

require 'json'
class Player	#Define Player class
	attr_accessor(:poke, :items, :money)	#Allow access to all variables of Player class
	def initialize
		@poke = Array.new		#Initialize the poke array that contains the pokecats captured by the player
		@items = Array.new		#Initialize the items array that contains the items bought by the player
		@money = 1000			#Initialize the amount of pocket money
	end
	
	def space		#This method prints space between different lines
		puts ""
	end
	
	def change_first_pokecat		#This method swaps the position of pokecats in the bag to determine which pokecat will get into battles first.
		is_changing = true
		while is_changing
			puts "Which pokecat do you want to put in the first slot?"
			index_array = [1, 2, 3, 4, 5, 6]
			@poke.each {|x| puts "#{index_array[@poke.index(x)]}. #{x.name}"}	#Print out the names of pokecats in the poke array
			choice = gets.chomp.to_i
			lucky_cat = @poke[choice - 1]		#Choose the cat that the player wants to put in the first position
			if lucky_cat.hp <= 0		#If the pokecat is dying, then it cannot battle
				puts "This cat is not able to battle right now!"
			else			#Else, the swap is successful
				@poke[0], @poke[choice - 1] = @poke[choice - 1], @poke[0]
				break
			end
		end
		puts "Successfully Swapped!"
		sleep 1
		space
	end
	
	def check_pokecats			#This method checks the stats of the pokecat selected by the player.
		is_changing = true
		while is_changing
			puts "Which pokecat's stats would you like to check?"
			index_array = [1, 2, 3, 4, 5, 6]
			@poke.each {|x| puts "#{index_array[@poke.index(x)]}. #{x.name}"}	#Print out the names of pokecats in the poke array
			choice = gets.chomp.to_i
			lucky_cat = @poke[choice - 1]		#Choose the cat that the player wants to check
			lucky_cat.print_stats				#Print out the stats of the cat
			puts "Exp: #{lucky_cat.exp}/#{lucky_cat.maxexp}"
			sleep 1
			space
			puts "Would you like to check another one? a. Yes b. No"	#Prompt the player whether he or she needs to check another pokecat
			choice = gets.chomp
			if choice == "b"		#If nahh then nahh
				is_changing = false
				space
			end
		end
	end
	
	def check_items			#This method checks the items the player has.
		n_cataball = 0		#Initialize the number of cataballs and catamins
		n_catamin = 0
		@items.each do |x|	#Count the number of cataballs and catamins
			case x.name
			when "Cataball" then n_cataball += 1
			when "Catamin" then n_catamin += 1
			end
		end
		puts "Item List:"		#Print out the item list
		puts "a. Cataball #{n_cataball}x"
		puts "b. Catamin #{n_catamin}x"
		puts "Your current pocket: #{@money}"
		space
		sleep 1
		return n_cataball, n_catamin	#Return the number of cataballs and catamins
	end
	
	def save
		data_hash = {
			:poke => Hash.new,
			:items => Hash.new,
			:money => @money
		}
		for n in 0...@poke.length
			data_hash[:poke].store("#{@poke[n].name}", @poke[n].lv)
		end
		n_cataball = 0
		n_catamin = 0
		@items.each do |x|
			case x.name
			when "Cataball" then n_cataball += 1
			when "Catamin" then n_catamin += 1
			end
		end
		data_hash[:items].store("Cataball", n_cataball)
		data_hash[:items].store("Catamin", n_catamin)
		puts "Saving..."
		sleep 2
		File.open("save.json", "w") {|f| f.write(data_hash.to_json)}
	end
	
	def load(handbook)
		f = File.read("save.json")
		data_hash = JSON.parse(f)
		@money = data_hash["money"]
		data_hash["poke"].each do |n, l|
			handbook.each do |x|
				if n == x.name
					y = x.dup
					y.lv = l
					y.set_stats
					@poke << y
				end
			end
		end
		n_cataball = data_hash["items"]["Cataball"]
		n_catamin = data_hash["items"]["Catamin"]
		n_cataball.times {@items << Cataball.new}
		n_catamin.times {@items << Catamin.new}
		puts "Loading..."
		sleep 2		
	end
end

class Cataball		#Define Cataball class
	attr_accessor(:name)	#Allow access to "name" variable of Player class
	def initialize
		@name = "Cataball"	#Initialize "name" variable
	end
	
	def gacha(obj, player)		#This method catches the wild pokecat and put it into the poke array of the player.
		puts "Mr.Q throws his legendary Cataball onto the wild pokecat!"
		3.times do
			print "..."
			sleep 1
		end
		chance = rand(10)		#Define the chance of successfully capturing the pokecat
		success = true
		if obj.hp >= 0.75 * obj.maxhp		#If the hp of the wild pokecat is over 75%, the chance is low.
			if chance > 6					#30% success rate
				puts "Gacha!!! Mr.Q successfully captured the new pokecat #{obj.name}!!!"
				copy = obj.dup			#Copy the wild pokecat
				copy.reset_stats		#Reset the changed stats (excluding hp) back to the original values
				player.poke << copy		#Put the copy into the poke array of the player
				obj.reset_stats			
				obj.hp = obj.maxhp		#Reset the hp of the enemy back to its original hp so that the next time it can still battle against the player
			else		#70% failure rate
				puts "Ahh the pokecat does not like this Cataball and runs away!!!"
				success = false
			end
		elsif (obj.hp >= 0.2 * obj.maxhp) && (obj.hp < 0.75 * obj.maxhp)	#If the hp of the wild pokecat is between 20% and 75%, the chance is medium
			if chance > 3			#60% success rate
				puts "Gacha!!! Mr.Q successfully captured the new pokecat #{obj.name}!!!"
				copy = obj.dup
				copy.reset_stats
				player.poke << copy
				obj.reset_stats
				obj.hp = obj.maxhp
			else
				puts "Ahh the pokecat does not like this Cataball and runs away!!!"
				success = false
			end
		else			#If the hp of the wild pokecat is below 20%, the success rate is 100%
			puts "Gacha!!! Mr.Q successfully captured the new pokecat #{obj.name}!!!"
			copy = obj.dup
			copy.reset_stats
			player.poke << copy
			obj.reset_stats
			obj.hp = obj.maxhp
		end
		sleep 1
		success		#Return whether or not the capture is successful
	end
end

class Catamin		#Define Catamin class
	attr_accessor(:name)
	def initialize
		@name = "Catamin"
	end
	
	def cure(player)	#This method cures one of the player's pokecat during a battle
		puts "Which pokecat would you like to cure?"
		index_array = [1, 2, 3, 4, 5, 6]
		player.poke.each {|x| puts "#{index_array[player.poke.index(x)]}. #{x.name}"}	
		choice = gets.chomp.to_i	
		lucky_cat = player.poke[choice - 1]		#Choose the pokecat the player wants to cure
		if lucky_cat.hp != lucky_cat.maxhp		#If the cat needs to be cured, cure it
			if (lucky_cat.hp + 50) <= lucky_cat.maxhp	#If the cat has much less hp, add 50 to it
				lucky_cat.hp += 50
			else			#If the cat has much hp but not maximum, cure its hp up to the maximum hp
				lucky_cat.hp = lucky_cat.maxhp
			end
		else		#If the cat is already healthy, then there is no need to use catamin to it
			puts "This cat does not need any Catamin!"
		end
	end
end