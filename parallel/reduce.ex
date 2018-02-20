#---
# Excerpted from "Seven Concurrency Models in Seven Weeks",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/pb7con for more book information.
#---
defmodule Parallel do
  def map(collection, fun) do
    parent = self()

    processes = Enum.map(collection, fn(e) ->
      p = spawn_link(fn() ->
            IO.puts "before send"
            send(parent, {self(), fun.(e)})
            IO.puts "after send"
          end)
        IO.puts "after spawn"
        p
      end)
      IO.puts "really after send loop"

    Enum.map(processes, fn(pid) ->
        receive do
          {^pid, result} ->
            IO.puts "result received"
            result
        end
      end)
  end
end
