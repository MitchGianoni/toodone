module TooDone
	class Task < ActiveRecord::Base
		belongs_to :list
	end
end