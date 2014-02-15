(ns bank.test (:use clojure.test))
(load-file "bank.clj")

;; The BankAccount module should support four calls:
;;
;; open-account
;; Called at the start of each test. Returns a BankAccount.
;;
;; close-account account
;; Called at the end of each test.
;;
;; balance account
;; Get the balance of the bank account.
;;
;; update-balance account amount
;; Increment the balance of the bank account by the given amount.
;; The amount may be negative for a withdrawal.
;;
;; The initial balance of the bank account should be 0.

(defn with-bank [label f]
  (let [acct (bank/open-account)
        result (f acct label)]
    (bank/close-account acct)
    result))

(deftest checking-basic-balance
  (with-bank "initial balance is 0" #(is (= 0 (bank/get-balance %1)) %2))
  (with-bank "incrementing and checking balance"
    #(do (is (= 0 (bank/get-balance %1)) %2)
         (is (= 10 (bank/update-balance %1 10)) %2)
         (is (= 10 (bank/get-balance %1)) %2))))

(deftest can-increment-and-decrement
  (with-bank "increment and decrement balance"
    #(do (is (= 0 (bank/get-balance %1)) %2)
         (is (= 10 (bank/update-balance %1 10)) %2)
         (is (= 0 (bank/update-balance %1 -10)) %2))))

(deftest check-concurrent-access
  (with-bank "handles concurrent execution"
    #(do
      (pcalls (bank/update-balance %1 10)
              (bank/update-balance %1 10)
              (bank/update-balance %1 10))
      (is (= 30 (bank/get-balance %1)) %2))))

(run-tests)
(shutdown-agents) ;; for the pcalls above so the test exits
