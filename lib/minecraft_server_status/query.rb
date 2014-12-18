require 'json'

module MinecraftServerStatus
  class Query

    attr_reader :host, :port

    def initialize(host, port=25565)
      raise ArgumentError.new('host is required') if host.nil?
      @host = host
      @port = port
    end

    def execute(options={})
      timeout_sec = options.fetch(:timeout_sec, 1)
      retry_limit = options.fetch(:retry_limit, 1)
      retry_count = 0
      errors = []

      while retry_count < retry_limit
        begin
          response = ""
          Timeout.timeout(timeout_sec) do
            begin
              # Connect
              socket = TCPSocket.open(host, port)

              # Send request
              socket.write(pack_data("\x00\x00" + pack_data(host.encode("UTF-8")) + pack_port(port) + "\x01"))
              socket.write(pack_data("\x00"))

              # Read response
              unpack_varint(socket)
              unpack_varint(socket)
              l = unpack_varint(socket)
              while response.length < l
                response += socket.recv(1024)
              end
            ensure
              # Close
              socket.close if socket
            end
          end
          response.force_encoding("UTF-8")
          json_response = JSON.parse(response.gsub(/\xC2\xA7./, ''))
          return Result.new(json_response, true, errors)
        rescue Exception => e
          errors << e
          retry_count += 1
        end
      end
      return Result.new(nil, false, errors)
    end

    private
    def unpack_varint(s)
      d = 0
      for i in 0..4
        b = s.recv(1).ord
        d |= (b & 0x7F) << 7*i
        if (b & 0x80).zero?
          break
        end
      end
      return d
    end

    def pack_varint(d)
      o = ""
      while true
        b = d & 0x7F
        d >>= 7
        o += [ b | (d > 0 ? 0x80 : 0) ].pack('C*')
        if d == 0
          break
        end
      end
      return o
    end

    def pack_data(d)
      return pack_varint(d.length) + d
    end

    def pack_port(i)
      return [i].pack('n*')
    end
    
  end
end
