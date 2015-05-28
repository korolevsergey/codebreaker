require_relative "codebreaker"

def restart_game(game)
  answer = gets.chomp.downcase
  if answer == "y" || answer == "yes"
    game.start
  else
    abort("Ciao!")
  end
end

def user_won (game)
  puts "You won!"
  save_result("won")
  puts "Do you want to play again? y/n"
  restart_game game
end

def user_lost (game)
  puts "You lost!"
  save_result("lost")
  puts "Do you want to play again? y/n"
  restart_game game
end

def save_result(won_or_lost)
  puts "Do you want to save your result?"
  answer = gets.chomp.downcase
  if answer == "y" || answer == "yes"
    puts "What is your name?"
    name = gets.chomp
    File.open("result.txt", 'a') do |f| 
      f.write("#{name} has #{won_or_lost} the game.\n")
    end
    puts "Your result is now safe.\n\n"
  end
end

puts "The code-breaker then gets some number of chances to break the code.\n 
In each turn, the code-breaker makes a guess of four numbers. \n
The code-maker then marks the guess with up to four + and - signs.\n
A + indicates an exact match: one of the numbers in the guess\n 
is the same as one of the numbers in the secret code and in the same position.\n
A - indicates a number match: one of the numbers in the guess\n
 is the same as one of the numbers in the secret code but in a different position.\n
Input you first attempt!\n
"
game = Codebreaker::Game.new
game.start

while (input = gets.chomp) do
  if(input == "help")
    print_help
  elsif (input == "hint")
    hint = game.hint
    if hint
      puts hint
    else
      puts "Sorry, buddy, you've already used your hint"
    end
  elsif (input == "exit")
    puts "See ya!"
    break
  else
    begin
      result = game.check(input)
      if result
        puts result
        if result == "++++"
          user_won game
        end
      else
        user_lost game
      end
    rescue
      puts "Values must be 4 digits, 1 to 6!"
    end
  end
end