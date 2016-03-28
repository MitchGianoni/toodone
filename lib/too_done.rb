require "too_done/version"
require "too_done/init_db"
require "too_done/user"
require "too_done/session"
require "too_done/list"
require "too_done/task"

require "thor"
require "pry"

module TooDone
  class App < Thor

    desc "add 'TASK'", "Add a TASK to a todo list."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list which the task will be filed under."
    option :date, :aliases => :d,
      :desc => "A Due Date in YYYY-MM-DD format."
    def add(task)
      thislist = List.find_or_create_by(title: options[:list], user_id: current_user.id)
      thistask = Task.find_or_create_by!(item: task, duedate: options[:date], completed: false, list_id: thislist.id)
      puts "Added task #{thistask.item} to #{thislist.title}"
    end

    desc "edit", "Edit a task from a todo list."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be edited."
    def edit
      list = List.find_by(title: options[:list], user_id: current_user.id)
      unless list
        puts "No such list. #{options[:list]}"
        exit
      end
      task = Task.where(list_id: list.id)
      unless task.count > 0
        puts "No tasks on this list"
        exit
      end
      task.each do |x|
        puts "#{x.id}, #{x.item}, #{x.duedate}, #{x.completed}, #{x.list_id}, \n"
      end
      puts "Edit which task?(enter task ID)"
      edit = STDIN.gets.chomp.to_i
      editor = Task.find_by(id: edit)
      puts "Update Title or Due Date? (T/D)"
      select = STDIN.gets.chomp.downcase
      unless select == 't' || 'd'
        puts "Wrong move idjit"
        exit
      end
      if select == "t"
        puts "New Title?"
        title = STDIN.gets.chomp.downcase
        editor.update(item: "#{title}")
        puts "New Title is now #{editor.item}"
      elsif select == "d"
        puts "New Due Date? (YYYY-MM-DD)"
        date = STDIN.gets.chomp.downcase
        editor.update(duedate: date)
        puts "New Due Date is now #{editor.duedate}"
      end
    end

    desc "done", "Mark a task as completed."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be completed."
    def done
      list = List.find_by(title: options[:list], user_id: current_user.id)
      unless list
        puts "No such list. #{options[:list]}"
        exit
      end
      task = Task.where(list_id: list.id)
      unless task.count > 0
        puts "No tasks on this list"
        exit
      end
      puts "Tasks in this list:"
      task.each do |x|
        puts "#{x.id}, #{x.item}, #{x.duedate}, #{x.completed}, #{x.list_id}, \n"
      end
      puts "Which task is complete?(enter task ID)"
      done = STDIN.gets.chomp.to_i
      donezo = Task.find_by(id: done)
      donezo.update(completed: true)
      puts "Task #{donezo.item} is now marked complete"
    end

    desc "show", "Show the tasks on a todo list in reverse order."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be shown."
    option :completed, :aliases => :c, :default => false, :type => :boolean,
      :desc => "Whether or not to show already completed tasks."
    option :sort, :aliases => :s, :enum => ['history', 'overdue'],
      :desc => "Sorting by 'history' (chronological) or 'overdue'.
      \t\t\t\t\tLimits results to those with a due date."
    def show
     # options[:sort] == "history"
     #  ...
     #elsif options[:sort]
      # find or create the right todo list
      # show the tasks ordered as requested, default to reverse order (recently entered first)
    end

    desc "delete [LIST OR USER]", "Delete a todo list or a user."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list which will be deleted (including items)."
    option :user, :aliases => :u,
      :desc => "The user which will be deleted (including lists and items)."
    def delete
      # BAIL if both list and user options are provided
      # BAIL if neither list or user option is provided
      # find the matching user or list
      # BAIL if the user or list couldn't be found
      # delete them (and any dependents)
    end

    desc "switch USER", "Switch session to manage USER's todo lists."
    def switch(username)
      user = User.find_or_create_by(name: username)
      user.sessions.create
    end

    private
    def current_user
      Session.last.user
    end
  end
end

# binding.pry
TooDone::App.start(ARGV)

# add
      # find or create the right todo list
      # create a new item under that list, with optional date
        # Alternate code:
        # => puts "Add task to which list?"
        # => list = STDIN.gets.chomp.downcase
        # => thislist = List.find_or_create_by!(title: list, user_id: current_user.id)
        # => puts "Due Date?(YYYY-MM-DD)"
        # => duedate = STDIN.gets.chomp.downcase
# done
      # find the right todo list
      # BAIL if it doesn't exist and have tasks
      # display the tasks and prompt for which one(s?) to mark done
# edit
      # find the right todo list
      # BAIL if it doesn't exist and have tasks
      # display the tasks and prompt for which one to edit
      # allow the user to change the title, due date
