require 'minitest/autorun'
require_relative 'ocr'

class OCRTest < MiniTest::Unit::TestCase

  def test_recognize_zero
    text = <<-NUMBER.chomp
 _ 
| |
|_|
   
    NUMBER
    assert_equal "0", OCR.new(text).convert
  end

  def test_recognize_one
    skip
    text = <<-NUMBER.chomp
   
  |
  |
   
    NUMBER
    assert_equal "1", OCR.new(text).convert
  end

  def test_recognize_two
    skip
    text = <<-NUMBER.chomp
 _ 
 _|
|_ 
   
    NUMBER
    assert_equal "2", OCR.new(text).convert
  end

  def test_recognize_three
    skip
    text = <<-NUMBER.chomp
 _ 
 _|
 _|
   
    NUMBER
    assert_equal "3", OCR.new(text).convert
  end

  def test_recognize_four
    skip
    text = <<-NUMBER.chomp
   
|_|
  |
   
    NUMBER
    assert_equal "4", OCR.new(text).convert
  end

  def test_recognize_five
    skip
    text = <<-NUMBER.chomp
 _ 
|_ 
 _|
   
    NUMBER
    assert_equal "5", OCR.new(text).convert
  end

  def test_recognize_six
    skip
    text = <<-NUMBER.chomp
 _ 
|_ 
|_|
   
    NUMBER
    assert_equal "6", OCR.new(text).convert
  end

  def test_recognize_seven
    skip
    text = <<-NUMBER.chomp
 _ 
  |
  |
   
    NUMBER
    assert_equal "7", OCR.new(text).convert
  end

  def test_recognize_eight
    skip
    text = <<-NUMBER.chomp
 _ 
|_|
|_|
   
    NUMBER
    assert_equal "8", OCR.new(text).convert
  end

  def test_recognize_nine
    skip
    text = <<-NUMBER.chomp
 _ 
|_|
 _|
   
    NUMBER
    assert_equal "9", OCR.new(text).convert
  end

  def test_identify_garble
    skip
    text = <<-NUMBER.chomp
   
| |
| |
   
    NUMBER
    assert_equal "?", OCR.new(text).convert
  end

  def test_identify_10
    skip
    text = <<-NUMBER.chomp
    _ 
  || |
  ||_|
      
    NUMBER
    assert_equal "10", OCR.new(text).convert
  end

  def test_identify_110101100
    skip
    text = <<-NUMBER.chomp
       _     _        _  _ 
  |  || |  || |  |  || || |
  |  ||_|  ||_|  |  ||_||_|
                           
    NUMBER
    assert_equal "110101100", OCR.new(text).convert
  end

  def test_identify_with_garble
    skip
    text = <<-NUMBER.chomp
       _     _           _ 
  |  || |  || |     || || |
  |  | _|  ||_|  |  ||_||_|
                           
    NUMBER
    assert_equal "11?10?1?0", OCR.new(text).convert

  end

  def test_identify_1234567890
    skip
    text = <<-NUMBER.chomp
    _  _     _  _  _  _  _  _ 
  | _| _||_||_ |_   ||_||_|| |
  ||_  _|  | _||_|  ||_| _||_|
                              
    NUMBER
    assert_equal "1234567890", OCR.new(text).convert
  end

  def test_identify_123_456_789
    skip
    text = <<-NUMBER.chomp
    _  _ 
  | _| _|
  ||_  _|
         
    _  _ 
|_||_ |_ 
  | _||_|
         
 _  _  _ 
  ||_||_|
  ||_| _|
         
NUMBER
    assert_equal "123,456,789", OCR.new(text).convert
  end

end
