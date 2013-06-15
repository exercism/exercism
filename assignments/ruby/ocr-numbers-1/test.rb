require 'minitest/autorun'
require 'minitest/pride'
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

  def test_identify_11
    skip
    text = <<-NUMBER.chomp
      
  |  |
  |  |
      
    NUMBER
    assert_equal "11", OCR.new(text).convert
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

end

