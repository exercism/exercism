Shift ciphers are no fun though when your kid sister figures it out. Try amending the code to allow us to specify a key and use that for the shift distance. This is called a substitution cipher.

Here's an example:

    @cipher = Cipher.new("aaaaaaaaaaaaaaaaaa")
    @cipher.encode("iamapandabear") #=> "iamapandabear"
    @cipher = Cipher.new("ddddddddddddddddd")
    @cipher.encode("imapandabear") #=> "ldpdsdqgdehdu"

In the example above, we've set a = 0 for the key value. So when the plaintext is added to the key, we end up with the same message coming out. So "aaaa" is not an ideal key. But if we set the key to "dddd", we would get the same thing as the Caesar Cipher.
