require_relative "codebreaker/version"

module Codebreaker

  class Game

    attr_reader :attempts

    def initialize(max_code_value=6, code_length=4, max_attempts=5)
      @max_code_value = max_code_value
      @code_length = code_length
      @max_attempts = max_attempts
      @secret_code = 4.times.map { rand(1..6) }.join
    end

    def start 
      @hint_is_given = false
      @attempts = 0
      @secret_code
    end

    def check(input)
      input = input
      return 'Incorrect_code' unless input.match(/^[1-6]{4}/)
      temp_code = @secret_code.clone
      
      @attempts += 1
      if @attempts > @max_attempts
        return false
      end

      result = ""

      (0...4).each do |index|
        if(temp_code[index] == input[index])
          result << "+"
          input[index] = "_"
          temp_code[index] = "_"
        end
      end

      # for some reason it doesn't update variable while in each_char loop
      # let's try with simple iteration

      (0...4).each do |index_out|
        (0...4).each do |index_in|
          if temp_code[index_out] == input[index_in] && input[index_in] != "_"
            temp_code[index_out] = "_"
            input[index_in] = "_"
            result << "-"
          end
        end
      end

      result
    end

    def hint
      if (!@hint_is_given)
        index = rand(0...4)
        @hint_is_given = true
        return @secret_code[index]
      else
        return false
      end
    end

  end
end