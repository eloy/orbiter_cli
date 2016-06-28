defmodule OrbiterCli do
  import OrbiterCli.CmdTools
  alias OrbiterCli.Orbiter
  alias OrbiterCli.DomoioApi

  def main([action | args]) do
    :net_kernel.start([:orbiter_cli])
    :hackney.start()
    try do
      run(action, args)
    rescue
      e in RuntimeError -> IO.puts "ERROR: #{e.message}"
    end
  end

  def main(_args) do
    IO.puts "Invalid action\n"
    show_help
  end

  defp run("setup", _args) do
    OrbiterCli.Setup.run()
  end

  defp run("help", _args) do
    show_help
  end


  defp show_help do
    IO.puts "Usage: orbiter_cli :action"
    IO.puts "Available actions:"
    IO.puts "\t-help\tShows this help."
    IO.puts "\t-setup\tConnects the device to the domoio network."
  end


  # helpers
  #----------------------------------------------------------------------

  def login do
    email = ask "Email"
    password = ask "Password"
    IO.puts "Email: #{email} => #{password}"
    case DomoioApi.get_token(email, password) do
      {:ok, token} -> token
      :error -> raise "Invalid login"
    end
  end



  def select_project(projects) do
    IO.puts "\n"
    Enum.reduce projects, 1, fn(project, index) ->
      IO.puts "#{index}\t#{project["name"]}"
      index + 1
    end
    case :io.get_line("Select a project: ") |> String.rstrip |> Integer.parse do
      :error ->
        IO.puts "Invalid selection"
        select_project(projects)

      {index, ""} ->
        if index > length(projects) do
          select_project(projects)
        else
          Enum.at projects, index - 1
        end
    end
  end


  def select_collection(collection, label_callback) do
    IO.puts "\n"
    Enum.reduce collection, 1, fn(item, index) ->
      label = label_callback.(item)
      IO.puts "#{index}\t#{label}"
      index + 1
    end
    case :io.get_line("Select a collection: ") |> String.rstrip |> Integer.parse do
      :error ->
        IO.puts "Invalid selection"
        select_collection(collection, label_callback)

      {index, ""} ->
        if index > length(collection) do
          select_collection(collection, label_callback)
        else
          Enum.at collection, index - 1
        end
    end
  end

end
