<?php

require realpath(__DIR__ . '/example.php');

class TrinaryTest extends PHPUnit_Framework_TestCase
{

  /**
   * @test
   */
  public function _1_is_decimal_1()
  {
    $this->assertEquals(1, (new Trinary('1'))->toDecimal());
  }

  /**
   * @skip
   */
  public function _2_is_decimal_2()
  {
    $this->assertEquals(2, (new Trinary('2'))->toDecimal());
  }

  /**
   * @skip
   */
  public function _10_is_decimal_3()
  {
    $this->assertEquals(3, (new Trinary('10'))->toDecimal());
  }

  /**
   * @skip
   */
  public function _11_is_decimal_4()
  {
    $this->assertEquals(4, (new Trinary('11'))->toDecimal());
  }

  /**
   * @skip
   */
  public function _100_is_decimal_9()
  {
    $this->assertEquals(9, (new Trinary('100'))->toDecimal());
  }

  /**
   * @skip
   */
  public function _112_is_decimal_14()
  {
    $this->assertEquals(14, (new Trinary('112'))->toDecimal());
  }

  /**
   * @skip
   */
  public function _222_is_decimal_26()
  {
    $this->assertEquals(26, (new Trinary('222'))->toDecimal());
  }

  /**
   * @skip
   */
  public function _1122000120_is_decimal_32091()
  {
    $this->assertEquals(32091, (new Trinary('1122000120'))->toDecimal());
  }

  /**
   * @skip
   */
  public function _invalid_trinary_is_decimal_0()
  {
    $this->assertEquals(0, (new Trinary('carrot'))->toDecimal());
  }

}
