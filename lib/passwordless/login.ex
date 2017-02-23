defmodule Passwordless.Login do
  defstruct [:hash, :id, :inserted_at, :user_id]

  @moduledoc false

  @type t :: %Passwordless.Login{}

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
    hashes_equal?(login, validator) and age(login) < ttl()
  end

  defp hashes_equal?(login, validator) do
    validator
    |> hash()
    |> hashes_equal?(login.hash, true)
  end

  defp hashes_equal?(<<x, left::binary>>, <<y, right::binary>>, acc) do
    hashes_equal?(left, right, :erlang.and(acc, x === y))
  end
  defp hashes_equal?("", "", acc), do: acc
  defp hashes_equal?(_, _, _), do: false

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

  defp ttl, do: Application.get_env(:passwordless, :login_ttl)

  defp hash(validator) do
    :sha256
    |> :crypto.hash(validator)
    |> Base.encode16()
  end
end
