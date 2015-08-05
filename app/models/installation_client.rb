class InstallationClient

  def initialize(rental, device_id)
    @rental    = rental
    @locker    = rental.locker
    @url       = URI('http://localhost:5000/')
    @device_id = device_id
  end


  def ping_retrieval
    params = {row: @locker.row,
              col: @locker.column,
              device_id: @device_id,
              state: 0 }
    Net::HTTP.post_form(@url, params)
  end

  def ping_drop_off
    params = {row: @locker.row,
              col: @locker.column,
              device_id: @device_id,
              state: 1 }
    Net::HTTP.post_form(@url, params)
  end

end
