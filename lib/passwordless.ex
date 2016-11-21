defmodule Passwordless do
  use Application

  alias Passwordless.{Login, LoginRepo}

  @spec generate_login_token(term) :: <<_::512>>
  def generate_login_token(user_id) do
    if login = LoginRepo.get_by_user_id(user_id), do: LoginRepo.delete(login)

    {login, token} = Login.generate(user_id)
    LoginRepo.insert(login)
    token
  end

  @spec redeem(<<_::512>>) :: {:ok, term} | :error
  def redeem(<<id::size(96), validator::size(416)>> = _token) do
    login = LoginRepo.get(<<id::size(96)>>)
    if login, do: LoginRepo.delete(login)

    if login && Login.valid?(login, <<validator::size(416)>>) do
      {:ok, login.user_id}
    else
      :error
    end
  end
  def redeem(_token), do: :error

  ## Callbacks

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link [worker(LoginRepo, [])],
      strategy: :one_for_one,
      name: Passwordless.Supervisor
  end
end
