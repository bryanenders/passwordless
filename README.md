# Passwordless

Passwordless authentication.

## Installation

  1. Add `passwordless` to your list of dependencies in `mix.exs`:

    ```elixir
    defp deps, do: [{:passwordless, "~> 0.0.2"}]
    ```

  2. Ensure `passwordless` is started before your application:

    ```elixir
    def application, do: [applications: [:passwordless]]
    ```
