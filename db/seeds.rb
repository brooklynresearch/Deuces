row_count = 9
column_count = 50

row_count.times do |r|
  column_count.times do |c|
    Locker.create(row: row, column: column)
  end
end
