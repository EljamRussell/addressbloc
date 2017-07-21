# use require_relative to include the address book
require_relative '../models/address_book'

class MenuController
  attr_reader :address_book

  def initialize
    @address_book = AddressBook.new
  end

  def main_menu
    # display the main menu options to the command line
    puts "Main Menu - #{address_book.entries.count} entries"
    puts "1 - View all entries"
    puts "2 - Create an entry"
    puts "3 - Search for an entry"
    puts "4 - Import entries from a CSV"
    puts "5 - Exit"
    print "Enter your selection: "

    # retrieve user input from the command line with gets
    # gets reads the next line from standard input
    selection = gets.to_i
    # use case to determine response to input
    case selection
    when 1
      system "clear"
      view_all_entries
      main_menu
    when 2
      system "clear"
      create_entry
      main_menu
    when 3
      system "clear"
      search_entries
      main_menu
    when 4
      system "clear"
      read_csv
      main_menu
    when 5
      puts "Good-bye!"
      # terminate program using exit(0)
      exit(0)
      # use else to catch invalid input
    else
      system "clear"
      puts "Sorry, that is not a valid input"
      main_menu
    end
  end

  def view_all_entries
    # iterate thru all entries
    address_book.entries.each do |entry|
      system "clear"
      puts entry.to_s
      #display submenu for each entry, submenu is at bottom of menu controller
      entry_submenu(entry)
    end

    system "clear"
    puts "End of entries"
  end

  def create_entry
    # clear the screen for display entry prompts
    system "clear"
    puts "New AddressBloc Entry"
    # use print to prompt user for each Entry attribute
    print "Name: "
    name = gets.chomp
    print "Phone number: "
    phone = gets.chomp
    print "Email: "
    email = gets.chomp

    # add new etnry to the address book using add entry
    address_book.add_entry(name, phone, email)

    system "clear"
    puts "New entry created"
  end

  def search_entries
    # get the name that user want to search for and store in var name
    print "Search by name: "
    name = gets.chomp
    # call search on address_book, return match or nil
    # it will never return an empty string bec import_from_csv will fail if no name entry
    match = address_book.binary_search(name)
    system "clear"
    # check if search returned a match, call a helper method, search_submenu
    # search_submenu displays list of operations for an entry: delete, edit, return to main menu
    # if no match, returns nil/false
    if match
      puts match.to_s
      search_submenu(match)
    else
      puts "No match found for #{name}"
    end
  end

  def read_csv
    # prompt user to enter the name of a csv file to import
    # use chomp to removes newlines and trailing spaces
    print "Enter CSV file to import: "
    file_name = gets.chomp

    # check to see if file name is empty and return to main if true
    if file_name.empty?
      system "clear"
      puts "No CSV file read"
      main_menu
    end

    # import the file, clear the screen, print number of entries read
    # wrap all commands in begin/rescue block. begin protects crashing
    begin
      entry_count = address_book.import_from_csv(file_name).count
      system "clear"
      puts "#{entry_count} new entries added from #{file_name}"
    rescue
      puts "#{file_name} is not a valid CSV file, please enter the name of a valid CSV file"
      read_csv
    end
  end

  def entry_submenu(entry)
    puts "n - next entry"
    puts "d - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"

    selection = gets.chomp

    case selection

    when "n"
    when "d"
      # call delete_entry, after deleted: return control to view_all_entries
      delete_entry(entry)
    when "e"
      # call edit_entry, then display sub-menu with entry_submenu
      edit_entry(entry)
      entry_submenu(entry)
    when "m"
      system "clear"
      main_menu
    else
      system "clear"
      puts "#{selection} is not a valid input"
      entry_submenu(entry)
    end
  end

  def delete_entry(entry)
    address_book.entries.delete(entry)
    puts "#{entry.name} has been deleted"
  end

  def edit_entry(entry)
    # Print ask for each data item, assign gets.chomp to a var for each item
    print "Updated name: "
    name = gets.chomp
    print "Updated phone number: "
    phone_number = gets.chomp
    print "Updated email: "
    email = gets.chomp
    # Use !attribute.empty? to set attributes only if a valid attrib is read
    entry.name = name if !name.empty?
    entry.phone_number = phone_number if !phone_number.empty?
    entry.email = email if !email.empty?
    system "clear"
    # print out entry with updated attributes
    puts "Updated entry:"
    puts entry
  end

  def search_submenu(entry)
    # print out the submenu
    puts "\nd - delete entry"
    puts "e - edit this entry"
    puts "m - return to main menu"

    # save the user input to selection
    selection = gets.chomp
    # case statement takes a specific action based on user input
    # d = call delete_entry;  e = call edit_entry;  m = return to main menu
    # input is no match = else clear screen and repeat search_submenu
    case selection
    when "d"
      system "clear"
      delete_entry(entry)
      main_menu
    when "e"
      edit_entry(entry)
      system "clear"
      main_menu
    when "m"
      system "clear"
      main_menu
    else
      system "clear"
      puts "#{selection} is not a valid input"
      puts entry.to_s
      search_submenu(entry)
    end
  end
end
