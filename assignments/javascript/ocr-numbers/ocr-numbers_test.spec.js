var ocr = require('./ocr');

describe('ocr', function () {

  it('recognizes zero', function () {
    expect(ocr.convert(
      " _ \n" +
      "| |\n" +
      "|_|\n" +
      "   "
    )).toBe('0');
  });

  xit('recognizes one', function () {
    expect(ocr.convert(
      "   \n" +
      "  |\n" +
      "  |\n" +
      "   "
    )).toBe('1');
  });

  xit('recognizes two', function () {
    expect(ocr.convert(
      " _ \n" +
      " _|\n" +
      "|_ \n" +
      "   "
    )).toBe('2');
  });

  xit('recognizes three', function () {
    expect(ocr.convert(
      " _ \n" +
      " _|\n" +
      " _|\n" +
      "   "
    )).toBe('3');
  });

  xit('recognizes four', function () {
    expect(ocr.convert(
      "   \n" +
      "|_|\n" +
      "  |\n" +
      "   "
    )).toBe('4');
  });

  xit('recognizes five', function () {
    expect(ocr.convert(
      " _ \n" +
      "|_ \n" +
      " _|\n" +
      "   "
    )).toBe('5');
  });

  xit('recognizes six', function () {
    expect(ocr.convert(
      " _ \n" +
      "|_ \n" +
      "|_|\n" +
      "   "
    )).toBe('6');
  });

  xit('recognizes seven', function () {
    expect(ocr.convert(
      " _ \n" +
      "  |\n" +
      "  |\n" +
      "   "
    )).toBe('7');
  });

  xit('recognizes eight', function () {
    expect(ocr.convert(
      " _ \n" +
      "|_|\n" +
      "|_|\n" +
      "   "
    )).toBe('8');
  });

  xit('recognizes nine', function () {
    expect(ocr.convert(
      " _ \n" +
      "|_|\n" +
      " _|\n" +
      "   "
    )).toBe('9');
  });

  xit('recognizes ten', function () {
    expect(ocr.convert(
      "    _ \n" +
      "  || |\n" +
      "  ||_|\n" +
      "      "
    )).toBe('10');
  });

  xit('identifies garble', function () {
    expect(ocr.convert(
      "   \n" +
      "| |\n" +
      "| |\n" +
      "   "
    )).toBe('?');
  });

  xit('converts 110101100', function () {
    expect(ocr.convert(
      "       _     _        _  _ \n" +
      "  |  || |  || |  |  || || |\n" +
      "  |  ||_|  ||_|  |  ||_||_|\n" +
      "                           "
    )).toBe('110101100');
  });

  xit('identifies garble mixed in', function () {
    expect(ocr.convert(
      "       _     _           _ \n" +
      "  |  || |  || |     || || |\n" +
      "  |  | _|  ||_|  |  ||_||_|\n" +
      "                           "
    )).toBe('11?10?1?0');
  });

  xit('converts 1234567890', function () {
    expect(ocr.convert(
      "    _  _     _  _  _  _  _  _ \n" +
      "  | _| _||_||_ |_   ||_||_|| |\n" +
      "  ||_  _|  | _||_|  ||_| _||_|\n" +
      "                              "
    )).toBe('1234567890');
  });

  xit('converts 123 456 789', function () {
    expect(ocr.convert(
      "    _  _ \n" +
      "  | _| _|\n" +
      "  ||_  _|\n" +
      "         \n" +
      "    _  _ \n" +
      "|_||_ |_ \n" +
      "  | _||_|\n" +
      "         \n" +
      " _  _  _ \n" +
      "  ||_||_|\n" +
      "  ||_| _|\n" +
      "         "
    )).toBe('123,456,789');
  });

});