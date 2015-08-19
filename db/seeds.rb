row_count = 9
column_count = 17

rows_with_large = [0,2,4,6]


row_count.times do |r|
  if rows_with_large.include?(r)
    #create large locker- in first column
    Locker.create(row: r, column: 0, large: true)
    #no locker in second column
    #
    #create 3rd - n column lockers for row
    (2...column_count).each do |c|
      Locker.create(row: r, column: c, large: false)
    end
  else

    column_count.times do |c|
      Locker.create(row: r, column: c, large: false)
    end

  end
end
