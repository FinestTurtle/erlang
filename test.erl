-module(test).
-export([start/0, client/2, server/0]).

%Whenever a process receives a message it will check to see if it either continue or stops.
client(N, ClientPID) ->
  ClientPID ! {N + 1, self()},
  receive
    continue ->
      io:format("Client Continuing... ~n", []),
      client(N + 1, ClientPID);
    stop ->
      io:format("Client Received 'Stop' command.  Stopping.~n", []),
      ClientPID ! done
  end.

%
server() ->
  receive
    done ->
      io:format("Server Received 'done'~n", []);
    {N, ServerPID} ->
      case (N < 10) of
        false -> ServerPID ! stop;
        true -> ServerPID ! continue
      end,
      io:format("Server got ~p ~n", [N]),
      server()
  end.

start() ->
  ServerPID = spawn(test, server, []),
  spawn(test, client, [0, ServerPID]).

