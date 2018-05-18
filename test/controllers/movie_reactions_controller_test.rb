require 'test_helper'

class MovieReactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @movie_reaction = movie_reactions(:one)
  end

  test "should get index" do
    get movie_reactions_url
    assert_response :success
  end

  test "should get new" do
    get new_movie_reaction_url
    assert_response :success
  end

  test "should create movie_reaction" do
    assert_difference('MovieReaction.count') do
      post movie_reactions_url, params: { movie_reaction: { liked: @movie_reaction.liked, movie_id: @movie_reaction.movie_id, user_id: @movie_reaction.user_id } }
    end

    assert_redirected_to movie_reaction_url(MovieReaction.last)
  end

  test "should show movie_reaction" do
    get movie_reaction_url(@movie_reaction)
    assert_response :success
  end

  test "should get edit" do
    get edit_movie_reaction_url(@movie_reaction)
    assert_response :success
  end

  test "should update movie_reaction" do
    patch movie_reaction_url(@movie_reaction), params: { movie_reaction: { liked: @movie_reaction.liked, movie_id: @movie_reaction.movie_id, user_id: @movie_reaction.user_id } }
    assert_redirected_to movie_reaction_url(@movie_reaction)
  end

  test "should destroy movie_reaction" do
    assert_difference('MovieReaction.count', -1) do
      delete movie_reaction_url(@movie_reaction)
    end

    assert_redirected_to movie_reactions_url
  end
end
