class InstallationClient

  def initialize(rental, device_id)
    @rental    = rental
    @locker    = rental.locker
    @url       = URI('http://localhost:5000/messages')
    @device_id = device_id
  end


  def ping_retrieval
    params = {row: @locker.row,
              col: @locker.column,
              device_id: @device_id,
              state: 0 }

    begin
      req = Net::HTTP::Post.new(@url, initheader = {'Content-Type' =>'application/json'})
      req.body = params.to_json
      res = Net::HTTP.start(@url.hostname, @url.port) do |http|
        http.request(req)
      end
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Errno::ECONNREFUSED,
       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
       puts 'issue'

    end
  end

  def ping_drop_off
    params = {row: @locker.row,
              col: @locker.column,
              device_id: @device_id,
              state: 0 }

    begin
      req = Net::HTTP::Post.new(@url, initheader = {'Content-Type' =>'application/json'})
      req.body = params.to_json
      res = Net::HTTP.start(@url.hostname, @url.port) do |http|
        http.request(req)
      end

    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Errno::ECONNREFUSED,
       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
       puts 'issue'

    end
  end

end
