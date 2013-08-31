<?php

require realpath(__DIR__ . '/example.php');

class WordProblemTest extends PHPUnit_Framework_TestCase
{

  /** @test */
  public function add_1() {
    $problem = new WordProblem('What is 1 plus 1?');
    $this->assertEquals(2, $problem->answer());
  }

  /** @skip */
  public function add_2() {
    $problem = new WordProblem('What is 53 plus 2?');
    $this->assertEquals(55, $problem->answer());
  }

  /** @skip */
  public function add_negative_numbers() {
    $problem = new WordProblem('What is -1 plus -10?');
    $this->assertEquals(-11, $problem->answer());
  }

  /** @skip */
  public function add_more_digits() {
    $problem = new WordProblem('What is 123 plus 45678?');
    $this->assertEquals(45801, $problem->answer());
  }

  /** @skip */
  public function subtract() {
    $problem = new WordProblem('What is 4 minus -12?');
    $this->assertEquals(16, $problem->answer());
  }

  /** @skip */
  public function multiply() {
    $problem = new WordProblem('What is -3 multiplied by 25?');
    $this->assertEquals(-75, $problem->answer());
  }

  /** @skip */
  public function divide() {
    $problem = new WordProblem('What is 33 divided by -3?');
    $this->assertEquals(-11, $problem->answer());
  }

  /** @skip */
  public function add_twice() {
    $problem = new WordProblem('What is 1 plus 1 plus 1?');
    $this->assertEquals(3, $problem->answer());
  }

  /** @skip */
  public function add_then_subtract() {
    $problem = new WordProblem('What is 1 plus 5 minus -2?');
    $this->assertEquals(8, $problem->answer());
  }

  /** @skip */
  public function subtract_twice() {
    $problem = new WordProblem('What is 20 minus 4 minus 13?');
    $this->assertEquals(3, $problem->answer());
  }

  /** @skip */
  public function subtract_then_add() {
    $problem = new WordProblem('What is 17 minus 6 plus 3?');
    $this->assertEquals(14, $problem->answer());
  }

  /** @skip */
  public function multiply_twice() {
    $problem = new WordProblem('What is 2 multiplied by -2 multiplied by 3?');
    $this->assertEquals(-12, $problem->answer());
  }

  /** @skip */
  public function add_then_multiply() {
    $problem = new WordProblem('What is -3 plus 7 multiplied by -2?');
    $this->assertEquals(-8, $problem->answer());
  }

  /** @skip */
  public function divide_twice() {
    $problem = new WordProblem('What is -12 divided by 2 divided by -3?');
    $this->assertEquals(2, $problem->answer());
  }

  /** @skip */
  public function too_advanced() {
    $this->setExpectedException('ArgumentError');

    $problem = new WordProblem('What is 53 cubed?');
    $problem->answer();
  }

  /** @skip */
  public function irrelevant() {
    $this->setExpectedException('ArgumentError');

    $problem = new WordProblem('Who is the president of the United States?');
    $problem->answer();
  }

}
