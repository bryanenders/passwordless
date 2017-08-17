# Passwordless

Passwordless is an Elixir library for generating and redeeming one-time
tokens.

These tokens can be used as a layer in a Multi-Factor Authentication (MFA)
scenario or in place of user passwords in a Single-Factor Authentication (SFA)
scenario. See: [360 million reasons to destroy all passwords](
https://medium.freecodecamp.com/9a100b2b5001
).

## Installation

  Add `passwordless` to your list of dependencies in `mix.exs`:
  
  ```elixir
  defp deps, do: [{:passwordless, "~> 0.1.0"}]
  ```

## Usage

```elixir
defp send_token(user) do
  user.id
  |> Passwordless.generate_login_token()
  |> email_login_link(user)
end
```

```elixir
defp create_session(token) do
  case Passwordless.redeem(token) do
    {:ok, user_id} -> MyApp.log_in(user_id)
    :error -> MyApp.handle_expired_token(token)
  end
end
```
