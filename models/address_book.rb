#  load the library using the relative address
require_relative 'entry'
require "csv"

class AddressBook
  attr_reader :entries

  def initialize
    @entries = []
  end

  def add_entry(name, phone_number, email)
    index = 0
    entries.each do |entry|
      if name < entry.name
        break
      end
      index += 1
    end
    entries.insert(index, Entry.new(name, phone_number, email))
  end

  def import_from_csv(file_name)
    # Implementation goes here
    csv_text = File.read(file_name)
    csv = CSV.parse(csv_text, headers: true, skip_blanks: true)
    csv.each do |row|
      row_hash = row.to_hash
      add_entry(row_hash["name"], row_hash["phone_number"], row_hash["email"])
    end
  end

  def iterative_search(name)
    @entries.each do |entry|
      if entry.name == name
        return entry
      end
    end

    return nil
  end

  # Search AdressBook for a specific entry by name
  # use var lower to save the index of the leftmost item in array
  def binary_search(name)
    lower = 0
    upper = entries.length - 1

    # use while loop while lower index less/equal upper index
    while lower <= upper
      # find middle index by sum of upper+lower / 2
      # ruby truncates decimals, save in mid_name
      mid = (lower + upper) / 2
      mid_name = entries[mid].name

      # compare search name to mid_name using == (case sensitive)
      # search name =  mid name....return
      # search name < mid name ....set upper to mid-1
      # search name > mid name ....set lower to mid+1
      if name == mid_name
        return entries[mid]
      elsif name < mid_name
        upper = mid - 1
      elsif name > mid_name
        lower = mid + 1
      end
    end

    # if no match found...return
    return nil
  end
end
