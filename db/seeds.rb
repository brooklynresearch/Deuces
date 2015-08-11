row_count = 9
column_count = 50


large_lockers = [[0,1], [0,2],[0,3],[0,4]]

row_count.times do |r|
  column_count.times do |c|
    large = large_lockers.include?([r,c])
    Locker.create(row: r, column: c, large: large)
  end
end
