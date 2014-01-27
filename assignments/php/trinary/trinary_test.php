<?php

require realpath(__DIR__ . '/trinary.php');

class TrinaryTest extends PHPUnit_Framework_TestCase {

  /** @test */
  public function test_1_is_decimal_1() {
    $trinary = new Trinary('1');
    $this->assertEquals(1, $trinary->toDecimal());
  }

  public function test_2_is_decimal_2() {
    $this->markTestSkipped();
    $trinary = new Trinary('2');
    $this->assertEquals(2, $trinary->toDecimal());
  }

  public function test_10_is_decimal_3() {
    $this->markTestSkipped();
    $trinary = new Trinary('10');
    $this->assertEquals(3, $trinary->toDecimal());
  }

  public function test_11_is_decimal_4() {
    $this->markTestSkipped();
    $trinary = new Trinary('11');
    $this->assertEquals(4, $trinary->toDecimal());
  }

  public function test_100_is_decimal_9() {
    $this->markTestSkipped();
    $trinary = new Trinary('100');
    $this->assertEquals(9, $trinary->toDecimal());
  }

  public function test_112_is_decimal_14() {
    $this->markTestSkipped();
    $trinary = new Trinary('112');
    $this->assertEquals(14, $trinary->toDecimal());
  }

  public function test_222_is_decimal_26() {
    $this->markTestSkipped();
    $trinary = new Trinary('222');
    $this->assertEquals(26, $trinary->toDecimal());
  }

  public function test_1122000120_is_decimal_32091() {
    $this->markTestSkipped();
    $trinary = new Trinary('1122000120');
    $this->assertEquals(32091, $trinary->toDecimal());
  }

  public function test_invalid_trinary_is_decimal_0() {
    $this->markTestSkipped();
    $trinary = new Trinary('carrot');
    $this->assertEquals(0, $trinary->toDecimal());
  }

}
