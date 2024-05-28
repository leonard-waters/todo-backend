defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BackendWeb do
    pipe_through :api

    resources "/lists", ListController, only: [:create, :show] do
      patch "/items/:id/done", ItemController, :mark_done
      resources "/items", ItemController, only: [:create, :show, :delete]
    end
  end
end
