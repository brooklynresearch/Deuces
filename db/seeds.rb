rows =  ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]


rows.each do |row|
  10.times do |column|
    Locker.create(row: row, column: column + 1)
  end
end
