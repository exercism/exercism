The rules are as follows:

* If the phone number is less than 10 digits assume that it is bad number
* If the phone number is 10 digits assume that it is good
* If the phone number is 11 digits and the first number is 1, trim the 1 and use the first 10 digits
* If the phone number is 11 digits and the first number is not 1, then it is a bad number
* If the phone number is more than 11 digits assume that it is a bad number

We've provided tests, now make them pass.

Hint: Only make one test pass at a time.
Disable the others, then flip each on in turn
after you get the current failing one to pass.
