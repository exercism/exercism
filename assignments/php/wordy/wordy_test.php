<?php

require realpath(__DIR__ . '/wordy.php');

class WordProblemTest extends PHPUnit_Framework_TestCase {

  /** @test */
  public function test_add_1() {
    $problem = new WordProblem('What is 1 plus 1?');
    $this->assertEquals(2, $problem->answer());
  }

  public function test_add_2() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is 53 plus 2?');
    $this->assertEquals(55, $problem->answer());
  }

  public function test_add_negative_numbers() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is -1 plus -10?');
    $this->assertEquals(-11, $problem->answer());
  }

  public function test_add_more_digits() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is 123 plus 45678?');
    $this->assertEquals(45801, $problem->answer());
  }

  public function test_subtract() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is 4 minus -12?');
    $this->assertEquals(16, $problem->answer());
  }

  public function test_multiply() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is -3 multiplied by 25?');
    $this->assertEquals(-75, $problem->answer());
  }

  public function test_divide() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is 33 divided by -3?');
    $this->assertEquals(-11, $problem->answer());
  }

  public function test_add_twice() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is 1 plus 1 plus 1?');
    $this->assertEquals(3, $problem->answer());
  }

  public function test_add_then_subtract() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is 1 plus 5 minus -2?');
    $this->assertEquals(8, $problem->answer());
  }

  public function test_subtract_twice() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is 20 minus 4 minus 13?');
    $this->assertEquals(3, $problem->answer());
  }

  public function test_subtract_then_add() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is 17 minus 6 plus 3?');
    $this->assertEquals(14, $problem->answer());
  }

  public function test_multiply_twice() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is 2 multiplied by -2 multiplied by 3?');
    $this->assertEquals(-12, $problem->answer());
  }

  public function test_add_then_multiply() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is -3 plus 7 multiplied by -2?');
    $this->assertEquals(-8, $problem->answer());
  }

  public function test_divide_twice() {
    $this->markTestSkipped();
    $problem = new WordProblem('What is -12 divided by 2 divided by -3?');
    $this->assertEquals(2, $problem->answer());
  }

  public function test_too_advanced() {
    $this->markTestSkipped();
    $this->setExpectedException('ArgumentError');

    $problem = new WordProblem('What is 53 cubed?');
    $problem->answer();
  }

  public function test_irrelevant() {
    $this->markTestSkipped();
    $this->setExpectedException('ArgumentError');

    $problem = new WordProblem('Who is the president of the United States?');
    $problem->answer();
  }

}
