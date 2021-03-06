defmodule AshJsonApi.Error.InvalidBody do
  @moduledoc """
  Returned when the request body provided is invalid
  """
  @detail @moduledoc
  @title "Invalid Body"
  @status_code 400

  use AshJsonApi.Error
  alias AshJsonApi.Error.SchemaErrors

  def new(opts) do
    json_xema_error = opts[:json_xema_error]

    opts_without_error = Keyword.delete(opts, :json_xema_error)

    json_xema_error
    |> SchemaErrors.all_errors(:json_pointer)
    |> Enum.map(fn %{path: path, message: message} ->
      opts_without_error
      |> Keyword.put(:detail, message)
      |> Keyword.put(:source_pointer, path)
      |> super()
    end)
  end
end
