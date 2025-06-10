require 'rails_helper'

RSpec.describe "API::Movies", type: :request do
  let!(:movie) { create(:movie) }
  let(:valid_attributes) do
    {
      title: "Interstellar",
      description: "Sci-fi space exploration film",
      director: "Christopher Nolan",
      producer: "Emma Thomas",
      release_date: "2014-11-07"
    }
  end

  let(:invalid_attributes) do
    {
      title: "",  # Invalid: empty title
      description: "Short",
      director: "",
      producer: "",
      release_date: "1800-01-01" # Invalid year
    }
  end

  describe "GET /api/movies" do
    it "returns a list of movies" do
      get "/api/movies"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to be_an(Array)
    end
  end

  describe "GET /api/movies/:id" do
    it "returns the requested movie" do
      get "/api/movies/#{movie.id}"
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["id"]).to eq(movie.id)
    end
  end

  describe "POST /api/movies" do
    context "with valid parameters" do
      it "creates a new movie" do
        expect {
          post "/api/movies", params: { movie: valid_attributes }
        }.to change(Movie, :count).by(1)

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["title"]).to eq("Interstellar")
      end
    end

    context "with invalid parameters" do
      it "does not create a new movie" do
        expect {
          post "/api/movies", params: { movie: invalid_attributes }
        }.not_to change(Movie, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /api/movies/:id" do
    it "updates the movie" do
      patch "/api/movies/#{movie.id}", params: { movie: { title: "Updated Title" } }
      expect(response).to have_http_status(:ok)
      expect(movie.reload.title).to eq("Updated Title")
    end
  end

  describe "DELETE /api/movies/:id" do
    it "soft deletes the movie" do
      delete "/api/movies/#{movie.id}"
      expect(response).to have_http_status(:no_content)
      expect(movie.reload.deleted_at).not_to be_nil
    end
  end
end
