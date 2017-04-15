package account

import "testing"

// The BankAccount module should define a type Account and support four calls:
//
// func OpenBank() : Account
//   Called at the start of each test. Returns an account handle.
//
// func CloseBank(account Account)
//   Called at the end of each test.
//
// func Balance(account Account) : int
//   Get the balance of the bank account.
//
// func Update(account Account, amount int)
//   Increment the balance of the bank account by the given amount.
//   The amount may be negative for a withdrawal.
//
// There should be a type Account which is returned from
//
// The initial value of the bank account should be 0.
//
// Remember that one of the guidelines in Effective Go is "share by
// communicating". Please assume in your design considerations that this is just
// a first prototype of an account system and that the final product will be
// much more complicated.

func assertBalance(t *testing.T, account Account, expected int) {
	if got := Balance(account); got != expected {
		t.Errorf("Balance(\"%v\"): Got \"%v\", expected \"%v\"", account, got, expected)
	}
}

func TestInitialBalanceZero(t *testing.T) {
	acc := OpenBank()
	defer CloseBank(acc)
	assertBalance(t, acc, 0)
}

func TestUpdateFromSameGoroutine(t *testing.T) {
	acc := OpenBank()
	defer CloseBank(acc)
	assertBalance(t, acc, 0)
	Update(acc, 10)
	assertBalance(t, acc, 10)
}

func TestUpdateFromDifferentGoroutine(t *testing.T) {
	acc := OpenBank()
	defer CloseBank(acc)
	assertBalance(t, acc, 0)
	c := make(chan int, 0)
	go func() {
		Update(acc, 10)
		c <- 1
	}()
	<-c
	assertBalance(t, acc, 10)
}
