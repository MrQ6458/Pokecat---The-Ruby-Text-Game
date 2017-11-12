# Pokecat v1.0 Description:
# 1. The idea of this game is based on my favorite game series, "Pokemon." 
#    It is a game in which the player catches different pokecats, train them, and beat different enemies with them. 
# 2. The battle system is completely the same as the old versions of Pokemon, 1v1. The pokecat with a higher speed attacks first.
# 3. Changes in this game compared to Pokemon:
#    1) This game deleted the 2 attributes of pokemons: special attack and special defense. 
#	 2) Because of the shortage of time spent on building this project, each pokecat only has 3 skills instead of 4.
#	 3) Unlike a list of common skills in Pokemon, each pokecat has its own fixed, unique skills with different effects. 
#	 4) The map is significantly smaller than Pokemon. If I had had enough time, I would have built much more like adding gyms and npcs and creating more stories.
#	 5) Also, I did not have time to build the "status" system like the one in Pokemon (Pokemons may be poisoned, paralysed, burnt, etc.)
# 	 6) The naming system is eliminated from this game, because the story is based on Mr.Q!!!
#	 7) The Computer system to store pokemons is also deleted, because Mr.Q carries all pokecats with his mysterious bag.
#    8) You can only save progress in Chinatown, because why not...
# 4. Yes, there is also an exp system in this game, and pokecats do evolve!! Flawless right? However, unlike Pokemon, you cannot cancel the evolution.
# 5. Each part of the code has illustration next to it to help you understand the structure better.
# 6. Still, this game needs much more improvements. But for now, 
# 7. just ENJOY THE GAME!!!

#Require access to the necessary header files
require_relative 'characters'
require_relative 'map'
require_relative 'player'

def space	 #This method prints space between different lines
	puts ""
end

def map_display(map, place)		#This method displays the map for the movement of the player
	row = map.detect{|p| p.include?(place)}	#Define the axises of the map, y as horizontal axis and x as vertical axis. (Yeah I know right? I should have swap x and y)
	x = map.index(row)
	y = row.index(place)		
	case x		#Define the vertical movement of the player on the map
	when 0
		up = " "
		down = map[x+1][y].name
	when 1
		up = map[x-1][y].name
		down = map[x+1][y].name
	when 2
		up = map[x-1][y].name
		down = " "
	end							
	case y		#Define the horizontal movement of the player on the map
	when 0
		left = " "
		right = map[x][y+1].name
	when 1
		left = map[x][y-1].name
		right = map[x][y+1].name
	when 2
		left = map[x][y-1].name
		right = " "
	end							
	puts "Map Display:"		#Print out the map in a neat arrangement
	puts "Up: #{up}".center(85)
	space
	puts "Left: #{left}".ljust(30) + "Your Location: #{place.name}".center(20) + "Right: #{right}".rjust(30)
	space
	puts "Down: #{down}".center(85)
	space
	sleep 1
	puts "Where would Mr.Q like to move? (u)p, (d)own, (l)eft, (r)ight, or (s)tay here?"	#Prompt for the direction of movement
	choice = gets.chomp.downcase
	case choice
	when "u" then place = map[x-1][y]
	when "d" then place = map[x+1][y]
	when "l" then place = map[x][y-1]
	when "r" then place = map[x][y+1]
	when "s" then place = map[x][y]
	end
	if choice == "s"
		puts "Mr.Q just loves this place so much that he does not want to leave at all."
		sleep 1
	else
		3.times do
			print "." * 6
			sleep 1
		end
		puts "After a long travel, Mr.Q is now at #{place.name}!"
		sleep 1
	end
	place		#Return the destination
end

def intro(player)	 #This method prints out the introduction and initializes the player
	puts "Pokecat v1.0"
	sleep 1
	puts "By Mr.Q"
	sleep 1
	puts "quuuu...
       !:.             .:!
        !``._________.''! 
         {             }
 .--.--, | .':.   .':. |
/__:  /  | '::' . '::' |
   / /   |`.   ._.   .'|
  / /    |.'         '.|
 /___-_-,|./  /   /  /.|
      // |''/.;   ;,/ '|
      `==|:=         =:|
         `.          .'
           :-._____.-:
          `''       `''"
	sleep 2
	puts "This is Mr.Q's personal story..."
	sleep 2
	puts "Back in 1860..."
	sleep 2
	puts "in the ancient Suzhou city..."
	sleep 2
	puts "This legendary boy, Stokes Qu,"
	sleep 2
	puts "saved the entire universe..."
	sleep 2
	puts "with his lovely companions..."
	sleep 2
	puts "Pokecats!!!!!!"
	sleep 1
	space
	sleep 1
	space
	sleep 1
	space
	puts "Doctor (96 years old): Mr.Q, would you like a pokecat?"
	sleep 2
	puts "Mr.Q: Aye sure bro. But could you explain to me why I am in this world..."
	sleep 2
	puts "Doctor: Go to those three cases and choose one pokecat."
	sleep 2
	puts "Mr.Q: Umm.. Why can't I get all three? And by the way why am I here..."
	sleep 2
	puts "Doctor: Because they are all Macho Cat. There is no meaning to get three of the same pokecat."
	sleep 2
	puts "Mr.Q gets a Macho Cat!"
	player.poke << Machocat.new(5)	#An object from 'characters.rb' is added into the poke array of the player object
	sleep 2
	puts "Mr.Q: Aight but why am I in this world? Why do I need to get a pokecat?"
	sleep 2
	puts "Doctor: Alright Mr.Q, now you can go have fun. Bye."
	sleep 2
	puts "Mr.Q: Hey! Why am I in this world? I wanna go back to my world and have fun with my girlfriend!"
	sleep 2
	puts "Doctor: Ohh wait here are some cataballs and catamins that you can use."
	sleep 2
	puts "Mr.Q gets 5 cataballs and 5 catamins!"
	5.times {player.items << Cataball.new}	#Item objects from 'player.rb' are added into the items array of the player object
	5.times {player.items << Catamin.new}
	sleep 2
	puts "Mr.Q: okay thanks but how can I go back to my real world? I don't wanna play games!"
	sleep 2
	puts "Doctor: Alright Mr.Q, now you can go have fun. Remember to find Amon. Bye."
	sleep 2
	puts "Mr.Q: Hey wait you old man!!!! Who is Amon?! How do I go back to my world?!"
	sleep 3
	player		#Return the initialized player object
end

#Initialize the game map
game_map = [
	[Chinatown.new, Catagrass.new, Ingsocity.new],
	[Catalake.new, Cataforest.new, Catacave.new],
	[Treasureisland.new, Roadofchampion.new, Amon.new]
]
#Define pokecat list for loading game
pokecat_list = [
	Machocat.new(0), Mohawkcat.new(0), Killercat.new(0), 
	Tankcat.new(0), Wallcat.new(0), Erasercat.new(0), 
	Warriorcat.new(0), Knightcat.new(0), Maniccat.new(0), 
	Ufocat.new(0), Dronecat.new(0), Blackhawkcat.new(0), 
	Fishcat.new(0), 
	Mightycatalord.new(0)
]


mrq = Player.new	#Create a new Player object called "mrq"
puts "Would you like to (l)oad game or (s)tart a new game?"		#Prompt for whether to load or to start new
my_choice = gets.chomp
case my_choice
when "l" then mrq.load(pokecat_list)		#Yes, I created a save already
when "s" then mrq = intro(mrq)
else puts "Well, if you want to create error, let's do it. The game will still go on, but you start off having nothing, and you may face ERRORS!!!"
end
place = game_map[0][0]		#Define the original place Mr.Q stays in
is_gaming = true			#Define a Boolean variable for the following loop to run
while is_gaming				#Continuously loop the game
	place = map_display(game_map, place)	#Get the next destination
	place.inquiry(mrq)	#Prompt the player what to do in this place
end
