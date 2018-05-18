class MovieReaction < ApplicationRecord
    # t.integer "movie_id"
    # t.integer "user_id"
    # t.boolean "liked"
    # t.datetime "created_at", null: false
    # t.datetime "updated_at", null: false
	belongs_to :user
	belongs_to :movie
	validate :owner_cant_like_him_self
	validates :movie_id, uniqueness: { scope: :user_id }


	def owner_cant_like_him_self
		user_id != movie.user_id
	end 
end
