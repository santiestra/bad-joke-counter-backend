require "kemal"

sockets = [] of HTTP::WebSocket

get "/new" do |env|
  user = env.params.query["user"]
  sockets.each do |socket|
    socket.send Hash{ "user" => user }.to_json
  end
  "New joke"
end

ws "/" do |socket|
  sockets.push socket

  # Handle incoming message and dispatch it to all connected clients
  socket.on_message do |message|
    sockets.each do |a_socket|
      a_socket.send message.to_json
    end
  end

  # Handle disconnection and clean sockets
  socket.on_close do |_|
    sockets.delete(socket)
    puts "Closing Socket: #{socket}"
  end
end

Kemal.run

