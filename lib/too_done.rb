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
      # find or create the right todo list
      # create a new item under that list, with optional date
    end

    desc "edit", "Edit a task from a todo list."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be edited."
    def edit
      # find the right todo list
      # BAIL if it doesn't exist and have tasks
      # display the tasks and prompt for which one to edit
      # allow the user to change the title, due date
    end

    desc "done", "Mark a task as completed."
    option :list, :aliases => :l, :default => "*default*",
      :desc => "The todo list whose tasks will be completed."
    def done
      # find the right todo list
      # BAIL if it doesn't exist and have tasks
      # display the tasks and prompt for which one(s?) to mark done
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
