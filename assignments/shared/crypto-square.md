The spaces and punctuation are removed from the English text and the
characters are written into a square (or rectangle) and the entire message is
downcased. For example, the sentence "If man was meant to stay on the ground
god would have given us roots" is 54 characters long, so it is written into a
rectangle with 7 rows and 8 columns.

```plain
ifmanwas
meanttos
tayonthe
groundgo
dwouldha
vegivenu
sroots
```

The coded message is obtained by reading down the columns going left to right.

For example, the message above is coded as:

```plain
imtgd vsfea rwerm ayoog
oanou uiont nnlvt wttdd
esaoh ghnss eoau
```

Write a program that, given an English text, outputs the encoded version of
that text.

The size of the square (number of columns) should be decided by the length of the message.

If the message is a length that creates a perfect square (e.g. 4, 9, 16, 25,
36, etc), use that number of columns.

If the message doesn't fit neatly into a square, choose the number of columns
that corresponds to the smallest square that is larger than the number of
characters in the message.

For example, a message 4 characters long should use a 2 x 2 square. A message
that is 81 characters long would use a square that is 9 colums wide.

A message between 5 and 8 characters long should use a rectangle 3 characters wide.

Output the encoded text in groups of five letters.

E.g.

```ruby
crypto = Crypto.new("Have a nice day. Feed the dog & chill out!")
crypto.normalize_plaintext
# => "haveanicedayfeedthedogchillout"
crypto.size
# => 36
crypto.plaintext_segments
# => ["havean", "iceday", "feedth", "edogch", "illout"]
crypto.ciphertext
# => "hifei acedl v..."
```
