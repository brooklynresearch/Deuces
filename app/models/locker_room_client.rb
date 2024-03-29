# test good url # @url = URI("http://www.mocky.io/v2/55c39e1a7c7d7b0a1468cacd")
# test bad url # @url = URI("http://www.mocky.io/v2/55c39e487c7d7b111468cace")
require 'net/http'

class LockerRoomClient

  def initialize(locker, device_id)
    @locker    = locker
    @url       = URI('http://localhost:5000/messages')
    @device_id = device_id
  end


  def ping_retrieval
    params = {row: @locker.row,
              col: @locker.column,
              device_id: @device_id,
              state: 0 }
    make_request(params)
  end

  def ping_drop_off
    params = {row: @locker.row,
              col: @locker.column,
              device_id: @device_id,
              state: 1 }
    make_request(params)
  end

  def ping_disabled
    params = {row: @locker.row,
              col: @locker.column,
              device_id: 5,
              state: 1 }
    make_request(params)
  end
private

  def make_request(params)
    begin
      req = Net::HTTP::Post.new(@url, initheader = {'Content-Type' =>'application/json'})
      req.body = params.to_json
      res = Net::HTTP.start(@url.hostname, @url.port) do |http|
        http.request(req)
      end
      res.code == "200"
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError, Errno::ECONNREFUSED,
       Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
       false
    end
  end
end
