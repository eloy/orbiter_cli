defmodule OrbiterCli.Orbiter do

  def server do
    :"orbiter@thin.local"
  end

  def public_key do
    :rpc.call(server, Orbiter.Config, :public_key, [])
  end

  def device_id do
    :rpc.call(server, Orbiter.Config, :device_id, [])
  end

  def set_device_id(device_id) do
    :rpc.call(server, Orbiter.Config, :set_device_id, [device_id])
  end

end
