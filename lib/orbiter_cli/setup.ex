defmodule OrbiterCli.Setup do
  import OrbiterCli.CmdTools
  alias OrbiterCli.DomoioApi

  def run do
    token = OrbiterCli.login()
    projects = DomoioApi.get_projects(token)
    project = OrbiterCli.select_project(projects)

    device = setup_loop(token, project)

    # Create a device
    OrbiterCli.Orbiter.set_device_id device["id"]
    IO.puts "Done."
  end


  defp setup_loop(token, project) do
    if confirm("Is this a new device?") do
      create_device(token, project)
    else
      select_device(token, project)
    end
  end

  defp create_device(token, project) do
    device_name = ask "Enter a name for this device"
    {:ok, public_key} = Orbiter.public_key
    DomoioApi.create_device token, project["id"], %{name: device_name, public_key: public_key, custom: true}
  end

  defp select_device(token, project) do
    devices = DomoioApi.get_devices(token, project["id"]) |> Enum.filter(fn(d)-> d["custom"] == true end)
    OrbiterCli.select_collection devices, fn(device) ->
      device["name"]
    end
  end
end
