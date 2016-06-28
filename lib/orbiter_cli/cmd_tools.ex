defmodule OrbiterCli.CmdTools do

  def ask(question) do
    :io.get_line("#{question}: ") |> String.rstrip
  end


  def confirm(question) do
    resp = ask("#{question} [S|n]") |> String.downcase
    case  resp do
      "n" -> false
      _other -> true
    end
  end
end
