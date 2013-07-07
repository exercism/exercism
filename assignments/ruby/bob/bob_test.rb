require 'minitest/autorun'
require 'minitest/pride'

begin
  require_relative 'bob'

  class TeenagerTest < MiniTest::Unit::TestCase
    attr_reader :teenager

    def setup
      @teenager = Bob.new
    end

    def test_stating_something
      assert_equal 'Whatever.', teenager.hey('Tom-ay-to, tom-aaaah-to.')
    end

    def test_shouting
      skip
      assert_equal 'Woah, chill out!', teenager.hey('WATCH OUT!')
    end

    def test_asking_a_question
      skip
      assert_equal 'Sure.', teenager.hey('Does this cryogenic chamber make me look fat?')
    end

    def test_talking_forcefully
      skip
      assert_equal 'Whatever.', teenager.hey("Let's go make out behind the gym!")
    end

    def test_shouting_numbers
      skip
      assert_equal 'Woah, chill out!', teenager.hey('1, 2, 3 GO!')
    end

    def test_shouting_with_special_characters
      skip
      assert_equal 'Woah, chill out!', teenager.hey('ZOMG THE %^*@#$(*^ ZOMBIES ARE COMING!!11!!1!')
    end

    def test_shouting_with_no_exclamation_mark
      skip
      assert_equal 'Woah, chill out!', teenager.hey('I HATE YOU')
    end

    def test_statement_containing_question_mark
      skip
      assert_equal 'Whatever.', teenager.hey('Ending with ? means a question.')
    end

    def test_silence
      skip
      assert_equal 'Fine. Be that way.', teenager.hey('')
    end

    def test_more_silence
      skip
      assert_equal 'Fine. Be that way.', teenager.hey(nil)
    end
  end

rescue LoadError => e

  def explain(something)
    7.times { puts }
    puts "Hit enter to continue..."
    gets
    7.times { puts }
    puts something
    puts
  end

  zomg = <<-ERROR
######## ########  ########   #######  ########  
##       ##     ## ##     ## ##     ## ##     ## 
##       ##     ## ##     ## ##     ## ##     ## 
######   ########  ########  ##     ## ########  
##       ##   ##   ##   ##   ##     ## ##   ##   
##       ##    ##  ##    ##  ##     ## ##    ##  
######## ##     ## ##     ##  #######  ##     ## 

  ERROR
  puts
  puts zomg

  explain "I'm going to\n* show you an error message,\n* then explain what you're seeing\n* then tell you how to fix it."
  explain "Seriously, don't freak out. It's not that bad."
  explain "OK, this is it:\n\n#{e.backtrace.first} #{e.message}"
  explain "First it tells you the name of the file where the error is occurring.\n\n\n\tbob_test.rb"
  explain "Then it tells you which line that error is on.\n\n\n\tbob_test.rb:5"

  explain "After that, it tells you the name of the method where the error is occurring.\n\n\n\tin `require_relative'."
  explain "Next, it tells you exactly what the error is.\n\n\n\tcannot load such file"
  explain "Finally, it tells you which file is missing.\n\n\n\t/path/to/your/code/ruby/bob/bob"
  explain "So the error is that on line 5. What's on line 5?\n\n\n\trequire_relative 'bob'"
  explain "Essentially, when we try to require the file, it says it's not there. You can fix the problem by creating an empty file named bob.rb inside of the ruby/bob directory."
  explain "Now take another look at the error message.\nDoes it make more sense?\n\n\n#{e.backtrace.first} #{e.message}"
  10.times { puts }
  exit!
end
