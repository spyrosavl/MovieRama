class Movie < ApplicationRecord
	# t.string "title"
	# t.integer "user_id"
	# t.string "description"
	# t.datetime "created_at", null: false
	# t.datetime "updated_at", null: false
	belongs_to :user
	validates :title, :description, presence: true
	has_many :movie_reactions, :dependent => :delete_all
	paginates_per 10

	def likes
		self.movie_reactions.where(liked: true).count || 0
	end

	def dislikes
		self.movie_reactions.where(liked: false).count || 0
	end
end
