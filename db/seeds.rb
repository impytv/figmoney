# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def save_recurrence_type(description, interval_type, interval_length)
    recurrence_type = RecurrenceType.new

    recurrence_type.description=description
    recurrence_type.interval_type=interval_type
    recurrence_type.interval_length=interval_length
    recurrence_type.recurrence_code= interval_type + interval_length.to_s

    recurrence_type.save
 end

def save_iteration(recurrence_type, n, i)
    iteration = Iteration.new

    iteration.recurrence_code=recurrence_type.recurrence_code
    iteration.interval_type=recurrence_type.interval_type
    iteration.stride=i
    iteration.iteration=n

    iteration.save
  end

RecurrenceType.delete_all

save_recurrence_type('Weekly', 'D', 7)
save_recurrence_type('Monthly', 'M', 1)
save_recurrence_type('Every two months', 'M', 2)
save_recurrence_type('Every three months', 'M', 3)
save_recurrence_type('Every four months', 'M', 4)
save_recurrence_type('Twice a year', 'M', 6)
save_recurrence_type('Yearly', 'M', 12)

Iteration.delete_all

RecurrenceType.all.each do |recurrence_type|
  i = 0
  n = 0
  while (recurrence_type.interval_type == 'D' && i < 730) || (recurrence_type.interval_type == 'M' && i < 24)
    save_iteration(recurrence_type, n, i)
    i = i + recurrence_type.interval_length
    n = n + 1
  end
end


