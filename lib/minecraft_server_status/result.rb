require 'base64'

module MinecraftServerStatus
  class Result
    attr_reader :raw,
                :alive,
                :errors,
                :version,
                :protocol,
                :num_max_players,
                :num_online_players,
                :description,
                :favicon

    def initialize(json_response, alive, errors)
      @raw    = json_response
      @alive  = alive
      @errors = errors
      if alive
        @version            = json_response["version"]["name"]
        @protocol           = json_response["version"]["protocol"]
        @num_max_players    = json_response["players"]["max"]
        @num_online_players = json_response["players"]["online"]
        @description        = json_response["description"]
        @favicon            = json_response["favicon"]
      end
    end

    def alive?
      alive
    end

    def export_favicon(dir_path=nil, file_name=nil)
      raise RuntimeError.new('server must be alive') if !alive? || favicon.nil?
      dir_path  ||= File.dirname(__FILE__) + '/'
      file_name ||= Time.now.strftime("%Y%m%d_%H%M%S") + '.png'
      file_path = dir_path + file_name

      # truncate newline and header
      base64_encoded_image = favicon.gsub(/[\r\n]/, '').gsub(/^data:image\/png;base64,/, '')
      
      begin
        FileUtils.mkdir_p(dir_path) unless FileTest.exist?(dir_path)
        File.open(file_path, 'wb') do |f|
          f.write(Base64.decode64(base64_encoded_image))
        end
      rescue Exception => e
        warn "failed to create image file: #{e}"
        return nil
      end

      if !check_image(file_path)
        warn 'invalid image format'
        return nil
      end

      return file_name
    end

    private
    def check_image(file_path)
      raise ArgumentError.new('file_path is required') if file_path.nil?

      result = false
      begin
        File.open(file_path, 'rb') do |f|
          head = f.read(8)
          result = head.unpack('CA3C4') == [0x89, 'PNG', 0xd, 0xa, 0x1a, 0xa]
        end
      rescue Exception => e
        result = false
      end
      return result
    end

  end
end
