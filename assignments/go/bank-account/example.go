package account

type Account chan interface{}

type MsgBalance struct {
	resultChan chan int
}

type MsgUpdate struct {
	resultChan chan int
	amount     int
}
type MsgClose struct {
	resultChan chan int
}

// OpenBank opens the bank by spawning the state process.
func OpenBank() Account {
	c := make(chan interface{}, 0)
	go runAccount(c, 0)
	return c
}

// CloseBank closes the bank.
func CloseBank(account Account) {
	c := make(chan int, 0)
	account <- MsgClose{c}
	<-c
	return
}

// Balance retrieves the account balance.
func Balance(account Account) int {
	c := make(chan int, 0)
	account <- MsgBalance{c}
	return <-c
}

// Update modifies the account balance.
func Update(account Account, amount int) {
	c := make(chan int, 0)
	account <- MsgUpdate{c, amount}
	<-c
	return
}

func runAccount(c chan interface{}, initial_balance int) {
	balance := initial_balance
	for {
		msg := <-c
		switch msg := msg.(type) {
		case MsgBalance:
			msg.resultChan <- balance
		case MsgUpdate:
			balance += msg.amount
			msg.resultChan <- balance // Isn't used, but we should send something
		case MsgClose:
			msg.resultChan <- 1
			break
		}
	}
}
