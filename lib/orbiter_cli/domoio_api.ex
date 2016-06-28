defmodule OrbiterCli.DomoioApi do

  def get_token(email, password) do
    payload = Poison.encode! %{user: %{email: email, password: password}}
    case :hackney.request(:post, "http://localhost:4000/api/get_token", [{"Content-Type", "application/json"}], payload, []) do
      {:ok, 200, _headers, ref} ->
        {:ok, body} = :hackney.body(ref)
        resp = Poison.decode! body
        {:ok, resp["token"]}
      {:ok, 401, _headers, _ref} ->
        :error
    end

  end


  def get_projects(token) do
    {:ok, 200, _headers, ref} = :hackney.request(:get, "http://localhost:4000/api/projects", [{"Content-Type", "application/json"}, {"authtoken", token}], "", [])
    {:ok, body} = :hackney.body(ref)
    Poison.decode! body
  end

  def get_devices(token, project_id) do
    {:ok, 200, _headers, ref} = :hackney.request(:get, "http://localhost:4000/api/projects/#{project_id}/devices", [{"Content-Type", "application/json"}, {"authtoken", token}], "", [])
    {:ok, body} = :hackney.body(ref)
    devices = Poison.decode! body
  end

  def create_device(token, project_id, device) do
    payload = Poison.encode! %{device: device}
    {:ok, 200, _headers, ref} = :hackney.request(:post, "http://localhost:4000/api/projects/#{project_id}/devices", [{"Content-Type", "application/json"}, {"authtoken", token}], payload, [])
    {:ok, body} = :hackney.body(ref)
    Poison.decode! body
  end

end
