row_count = 9
column_count = 17


large_lockers = [[0,1], [0,2],[0,3],[0,4][0,5][0,6]]

row_count.times do |r|
  column_count.times do |c|
    large = large_lockers.include?([r,c])
    Locker.create(row: r, column: c, large: large)
  end
end
