require 'minitest/autorun'

begin
  require_relative 'bob'
rescue LoadError => e
  eval("\"#{DATA.read}\n\"").split("\n.\n").each_with_index do |s,i|
    if i > 0
      puts "\t--- press enter to continue ---"
      gets
    end
    puts "\n\n", s, "\n\n\n"
  end
  exit!
end

class TeenagerTest < MiniTest::Unit::TestCase
  attr_reader :teenager

  def setup
    @teenager = ::Bob.new
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

  def test_asking_a_numeric_question
    skip
    assert_equal 'Sure.', teenager.hey('You are, what, like 15?')
  end

  def test_talking_forcefully
    skip
    assert_equal 'Whatever.', teenager.hey("Let's go make out behind the gym!")
  end

  def test_using_acronyms_in_regular_speech
    skip
    assert_equal 'Whatever.', teenager.hey("It's OK if you don't want to go to the DMV.")
  end

  def test_forceful_questions
    skip
    assert_equal 'Woah, chill out!', teenager.hey('WHAT THE HELL WERE YOU THINKING?')
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

  def test_prattling_on
    skip
    assert_equal 'Sure.', teenager.hey("Wait! Hang on. Are you going to be OK?")
  end

  def test_silence
    skip
    assert_equal 'Fine. Be that way!', teenager.hey('')
  end

  def test_prolonged_silence
    skip
    assert_equal 'Fine. Be that way!', teenager.hey('    ')
  end

  def test_on_multiple_line_questions
    skip
    assert_equal 'Whatever.', teenager.hey(%{
Does this cryogenic chamber make me look fat?
no})
  end
end
__END__

######## ########  ########   #######  ########
##       ##     ## ##     ## ##     ## ##     ##
##       ##     ## ##     ## ##     ## ##     ##
######   ########  ########  ##     ## ########
##       ##   ##   ##   ##   ##     ## ##   ##
##       ##    ##  ##    ##  ##     ## ##    ##
######## ##     ## ##     ##  #######  ##     ##


#{e.backtrace.first} #{e.message}

Welcome to your first ruby Exercism exercise!  This is your first error message.
.
First it tells you the name of the file where the error is occurring:

    bob_test.rb
.
Then it tells you which line that error is on:

    bob_test.rb:4
.
After that, it tells you the name of the method where the error is occurring:

    in `require_relative'
.
Next, it tells you exactly what the error is:

    #{e.message.split('--').first}
.
Finally, it tells you which file is missing:

    #{e.message.split('--').last}
.
So the error is there on line 4 of this file (bob_test.rb).  What's on line 4?

    require_relative 'bob'

We are trying to require the file, and it isn't there.
.
You can fix the problem by creating an empty file named bob.rb inside
of the ruby/bob directory.

Then run this test again (ruby bob_test.rb).  Make all the tests pass,
and submit your solution (exercism submit bob.rb).

More instructions are in README.md in this directory. Good luck!
