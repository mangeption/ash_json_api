defmodule AshJsonApi.JsonApiResource.Routes do
  @moduledoc "DSL builders for configuring the routes of a json api resource"
  defmacro routes(path, do: body) do
    quote do
      import AshJsonApi.JsonApiResource.Routes
      @json_api_path unquote(path)
      unquote(body)
      import AshJsonApi.JsonApiResource.Routes, only: []
    end
  end

  defmacro get(action, opts \\ []) do
    quote bind_quoted: [action: action, opts: opts] do
      route = opts[:route] || "/:id"

      unless Enum.find(Path.split(route), fn part -> part == ":id" end) do
        raise "Route for get action *must* contain an `:id` path parameter"
      end

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :get,
                         controller: AshJsonApi.Controllers.Get,
                         action: action,
                         action_type: :read,
                         type: :get,
                         primary?: opts[:primary?] || false
                       )
    end
  end

  defmacro index(action, opts \\ []) do
    quote bind_quoted: [action: action, opts: opts] do
      route = opts[:route] || "/"

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :get,
                         controller: AshJsonApi.Controllers.Index,
                         action: action,
                         action_type: :read,
                         type: :index,
                         paginate?: Keyword.get(opts, :paginate?, true),
                         primary?: opts[:primary?] || false
                       )
    end
  end

  defmacro post(action, opts \\ []) do
    quote bind_quoted: [action: action, opts: opts] do
      route = opts[:route] || "/"

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :post,
                         controller: AshJsonApi.Controllers.Post,
                         action: action,
                         type: :post,
                         action_type: :create,
                         primary?: opts[:primary?] || false
                       )
    end
  end

  defmacro patch(action, opts \\ []) do
    quote bind_quoted: [action: action, opts: opts] do
      route = opts[:route] || "/:id"

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :patch,
                         controller: AshJsonApi.Controllers.Update,
                         action: action,
                         type: :patch,
                         action_type: :update,
                         primary?: opts[:primary?] || false
                       )
    end
  end

  defmacro delete(action, opts \\ []) do
    quote bind_quoted: [action: action, opts: opts] do
      route = opts[:route] || "/:id"

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :delete,
                         type: :delete,
                         controller: AshJsonApi.Controllers.Delete,
                         action: action,
                         action_type: :delete,
                         primary?: opts[:primary?] || false
                       )
    end
  end

  defmacro relationship_read_routes(relationship, opts \\ []) do
    quote bind_quoted: [relationship: relationship, opts: opts] do
      except = opts[:except] || []

      unless :relationship in except do
        relationship(relationship, opts)
      end

      unless :related in except do
        related(relationship, opts)
      end
    end
  end

  defmacro relationship_change_routes(relationship, opts \\ []) do
    quote bind_quoted: [relationship: relationship, opts: opts] do
      except = opts[:except] || []

      unless :post in except do
        post_to_relationship(relationship, opts)
      end

      unless :patch in except do
        patch_relationship(relationship, opts)
      end

      unless :delete in except do
        delete_from_relationship(relationship, opts)
      end
    end
  end

  defmacro related(relationship, opts \\ []) do
    quote bind_quoted: [relationship: relationship, opts: opts] do
      route = opts[:route] || ":id/#{relationship}"

      unless Enum.find(Path.split(route), fn part -> part == ":id" end) do
        raise "Route for get action *must* contain an `:id` path parameter"
      end

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :get,
                         controller: AshJsonApi.Controllers.GetRelated,
                         primary?: opts[:primary?] || true,
                         action: opts[:action] || :default,
                         relationship: relationship
                       )
    end
  end

  defmacro relationship(relationship, opts \\ []) do
    quote bind_quoted: [relationship: relationship, opts: opts] do
      route = opts[:route] || ":id/relationships/#{relationship}"

      unless Enum.find(Path.split(route), fn part -> part == ":id" end) do
        raise "Route for get action *must* contain an `:id` path parameter"
      end

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :get,
                         controller: AshJsonApi.Controllers.GetRelationship,
                         primary?: opts[:primary?] || true,
                         action: opts[:action] || :default,
                         relationship: relationship
                       )
    end
  end

  defmacro post_to_relationship(relationship, opts \\ []) do
    quote bind_quoted: [relationship: relationship, opts: opts] do
      route = opts[:route] || ":id/relationships/#{relationship}"

      unless Enum.find(Path.split(route), fn part -> part == ":id" end) do
        raise "Route for post to relationship action *must* contain an `:id` path parameter"
      end

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :post,
                         controller: AshJsonApi.Controllers.PostToRelationship,
                         primary?: opts[:primary?] || true,
                         action: opts[:action] || :default,
                         type: :post_to_relationship,
                         relationship: relationship
                       )
    end
  end

  defmacro patch_relationship(relationship, opts \\ []) do
    quote bind_quoted: [relationship: relationship, opts: opts] do
      route = opts[:route] || ":id/relationships/#{relationship}"

      unless Enum.find(Path.split(route), fn part -> part == ":id" end) do
        raise "Route for patch relationship action *must* contain an `:id` path parameter"
      end

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :patch,
                         controller: AshJsonApi.Controllers.PatchRelationship,
                         primary?: opts[:primary?] || true,
                         action: opts[:action] || :default,
                         type: :patch_relationship,
                         relationship: relationship
                       )
    end
  end

  defmacro delete_from_relationship(relationship, opts \\ []) do
    quote bind_quoted: [relationship: relationship, opts: opts] do
      route = opts[:route] || ":id/relationships/#{relationship}"

      unless Enum.find(Path.split(route), fn part -> part == ":id" end) do
        raise "Route for patch relationship action *must* contain an `:id` path parameter"
      end

      @json_api_routes AshJsonApi.JsonApiResource.Route.new(
                         route:
                           AshJsonApi.JsonApiResource.Routes.prefix(
                             route,
                             @json_api_path,
                             Keyword.get(opts, :prefix?, true)
                           ),
                         method: :delete,
                         controller: AshJsonApi.Controllers.DeleteFromRelationship,
                         primary?: opts[:primary?] || true,
                         action: opts[:action] || :default,
                         type: :delete_from_relationship,
                         relationship: relationship
                       )
    end
  end

  def prefix(route, path, true) do
    path =
      case path do
        "/" <> _rest_path -> path
        path -> "/" <> path
      end

    full_route = "/" <> path <> "/" <> String.trim_leading(route, "/")

    String.trim_trailing(full_route, "/")
  end

  def prefix(route, _name, _) do
    route
  end
end
