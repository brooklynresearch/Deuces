row_count = 9
column_count = 50

row_count.times do |r|
  column_count.times do |c|
    Locker.create(row: r, column: c)
  end
end
