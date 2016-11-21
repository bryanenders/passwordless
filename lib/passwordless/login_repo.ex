defmodule Passwordless.LoginRepo do
  alias Passwordless.Login

  @type on_start :: {:ok, pid} | {:error, {:already_started, pid} | term}

  @spec start_link() :: on_start
  def start_link do
    Agent.start_link(fn -> %{data: %{}, user_id_idx: %{}} end, name: __MODULE__)
  end

  @spec get(<<_::96>>) :: Login.t | nil
  def get(id), do: Agent.get(__MODULE__, fn %{data: data} -> data[id] end)

  @spec get_by_user_id(term) :: Login.t | nil
  def get_by_user_id(user_id) do
    Agent.get __MODULE__, fn %{data: data, user_id_idx: user_id_idx} ->
      id = user_id_idx[user_id]
      data[id]
    end
  end

  @spec insert(Login.t) :: :ok
  def insert(%Login{id: id, user_id: user_id} = login) do
    Agent.update __MODULE__, fn %{data: data, user_id_idx: user_id_idx} ->
      login = %Login{login | inserted_at: DateTime.utc_now}
      %{
        data: Map.put(data, id, login),
        user_id_idx: Map.put(user_id_idx, user_id, id),
      }
    end
  end

  @spec delete(Login.t) :: :ok
  def delete(%Login{id: id, user_id: user_id}) do
    Agent.update __MODULE__, fn %{data: data, user_id_idx: user_id_idx} ->
      %{
        data: Map.delete(data, id),
        user_id_idx: Map.delete(user_id_idx, user_id),
      }
    end
  end
end
