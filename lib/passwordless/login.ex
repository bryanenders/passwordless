defmodule Passwordless.Login do
  defstruct id: nil, hash: nil, user_id: nil, inserted_at: nil

  @type t :: %Passwordless.Login{}

  @ttl Application.get_env(:passwordless, :login_ttl)

  @spec generate(term) :: {t, <<_::512>>}
  def generate(user_id) do
    id        = rand_base64(12)
    validator = rand_base64(52)
    login     = %__MODULE__{id: id, hash: hash(validator), user_id: user_id}

    {login, id <> validator}
  end

  defp rand_base64(length) when rem(length, 4) == 0 do
    length * 3 / 4
    |> round()
    |> :crypto.strong_rand_bytes()
    |> Base.encode64()
  end

  @spec valid?(t, <<_::416>>) :: boolean
  def valid?(%__MODULE__{} = login, validator) do
    hash(validator) === login.hash and age(login) < @ttl
  end

  defp age(login) do
    now = :calendar.universal_time |> :calendar.datetime_to_gregorian_seconds()
    inserted_at =
      login
      |> Map.get(:inserted_at)
      |> DateTime.to_naive()
      |> NaiveDateTime.to_erl()
      |> :calendar.datetime_to_gregorian_seconds()

    now - inserted_at
  end

  defp hash(validator) do
    :sha256
    |> :crypto.hash(validator)
    |> Base.encode16()
  end
end
