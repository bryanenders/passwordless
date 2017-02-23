defmodule Passwordless.Application do
  use Application

  alias Passwordless.LoginRepo

  ## Callbacks

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link [worker(LoginRepo, [])],
      strategy: :one_for_one,
      name: Passwordless.Supervisor
  end
end
