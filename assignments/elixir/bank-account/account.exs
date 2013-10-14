defmodule BankAccount do
  @moduledoc """
  A bank account that supports access from multiple processes.
  """

  use GenServer.Behaviour
  
  ## Callbacks
  
  def init(_args) do
    { :ok, 0 }
  end

  def handle_call(:balance, _from, balance) do
    { :reply, balance, balance }
  end

  def handle_call({ :update, amount }, _from, balance) do
    { :reply, :ok, balance + amount }
  end

  def handle_call(:close, _from, balance) do
    # We stop normally and return :stopped to the caller.
    { :stop, :normal, :stopped, balance }
  end
  
  ## Interface for tests
  
  @typedoc """
  An account handle.
  """
  @opaque account :: pid

  @doc """
  Open the bank. Makes the account available.
  """
  @spec open_bank() :: account
  def open_bank() do
    { :ok, pid } = :gen_server.start_link(BankAccount, [], [])
    pid
  end

  @doc """
  Close the bank. Makes the account unavailable.
  """
  @spec close_bank(account) :: none
  def close_bank(account) do
    :gen_server.call(account, :close)
  end

  @doc """
  Get the account's balance.
  """
  @spec balance(account) :: integer
  def balance(account) do
    :gen_server.call(account, :balance) 
  end
 
  @doc """
  Update the account's balance by adding the given amount which may be negative.
  """
  def update(account, amount) do
    :gen_server.call(account, { :update, amount })
  end
end
