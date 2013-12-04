Code.load_file("account.exs")
ExUnit.start

# The BankAccount module should support four calls:
#
# open_bank()
#   Called at the start of each test. Returns an account handle.
#
# close_bank(account)
#   Called at the end of each test.
#
# balance(account)
#   Get the balance of the bank account.
#
# update(account, amount)
#   Increment the balance of the bank account by the given amount.
#   The amount may be negative for a withdrawal.
#
# The initial value of the bank account should be 0.

defmodule BankAccountTest do
  use ExUnit.Case, async: false # Tests should not overlap in execution.
  doctest BankAccount

  setup do
    account = BankAccount.open_bank()
    { :ok, [ account: account ] }
  end

  teardown context do
    BankAccount.close_bank(context[:account])
    :ok
  end

  test "initial balance is 0", context do
    assert BankAccount.balance(context[:account]) == 0
  end

  test "incrementing and checking balance", context do
    assert BankAccount.balance(context[:account]) == 0
    BankAccount.update(context[:account], 10)
    assert BankAccount.balance(context[:account]) == 10
  end

  test "incrementing balance from another process then checking it from test process", context do
    assert BankAccount.balance(context[:account]) == 0
    this = self()
    Process.spawn(fn ->
      BankAccount.update(context[:account], 20)
      this <- :continue
    end)
    receive do
      :continue -> :ok
    after 
      1000 -> flunk("Timeout") 
    end
    assert BankAccount.balance(context[:account]) == 20
  end
end
