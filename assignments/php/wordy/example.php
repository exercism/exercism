<?php

error_reporting(-1);

class ArgumentError extends InvalidArgumentException {}

class WordProblem
{

  private $BINARY_OPERATORS;

  public function __construct($question = '') {
    $this->BINARY_OPERATORS = [
      'plus'          => function($l, $r) { return $l + $r; },
      'minus'         => function($l, $r) { return $l - $r; },
      'multiplied by' => function($l, $r) { return $l * $r; },
      'divided by'    => function($l, $r) { return $l / $r; }
    ];

    $this->question = $question;

    preg_match($this->pattern(), $this->question, $this->matches);
  }

  public function operators() {
    return array_keys($this->BINARY_OPERATORS);
  }

  public function pattern() {
    $operations = sprintf(' (%s) ', join('|', $this->operators()));

    return join('', [
      '/(?:what is ([-+]?[\d]+)', $operations, '([-+]?[\d]+)(?:', $operations, '([-+]?[\d]+))?)/i'
    ]);
  }

  public function tooComplicated() {
    return !count($this->matches);
  }

  public function answer() {
    if ($this->tooComplicated()) {
      throw new ArgumentError("I don't understand the question");
    }

    return $this->evaluate();
  }

  public function evaluate() {
    $out = 0;
    $m   = $this->matches;

    if (!empty($m[1]) && !empty($m[2]) && !empty($m[3])) {
      $out = $this->operate($m[2], $m[1], $m[3]);
    }

    if (!empty($m[4]) && !empty($m[5])) {
      $out = $this->operate($m[4], $out, $m[5]);
    }

    return $out;
  }

  public function operate($operation, $l, $r) {
    $fn = function() { return 0; };

    if (!empty($this->BINARY_OPERATORS[$operation])) {
      $fn = $this->BINARY_OPERATORS[$operation];
    }

    return $fn((int) $l, (int) $r);
  }

}
