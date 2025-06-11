require 'rails_helper'

RSpec.describe "API::Movies", type: :request do
  let!(:movie) { create(:movie) }
  let(:admin) { create(:user, isAdmin: true) }
  let(:user)  { create(:user, isAdmin: false) }

  let(:admin_token) { JsonWebToken.encode(user_id: admin.id) }
  let(:user_token)  { JsonWebToken.encode(user_id: user.id) }

  let(:headers) do
    { "Authorization" => "Bearer #{admin_token}" }
  end

  let(:user_headers) do
    { "Authorization" => "Bearer #{user_token}" }
  end

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
      title: "",
      description: "Short",
      director: "",
      producer: "",
      release_date: "1800-01-01"
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
    context "as admin" do
      it "creates a new movie" do
        expect {
          post "/api/movies", params: { movie: valid_attributes }, headers: headers
        }.to change(Movie, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "as regular user" do
      it "returns forbidden" do
        post "/api/movies", params: { movie: valid_attributes }, headers: user_headers
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "without token" do
      it "returns unauthorized" do
        post "/api/movies", params: { movie: valid_attributes }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /api/movies/:id" do
    context "as admin" do
      it "updates the movie" do
        patch "/api/movies/#{movie.id}", params: { movie: { title: "Updated Title" } }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(movie.reload.title).to eq("Updated Title")
      end
    end

    context "as regular user" do
      it "returns forbidden" do
        patch "/api/movies/#{movie.id}", params: { movie: { title: "Updated Title" } }, headers: user_headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /api/movies/:id" do
    context "as admin" do
      it "soft deletes the movie" do
        delete "/api/movies/#{movie.id}", headers: headers
        expect(response).to have_http_status(:no_content)
        expect(movie.reload.deleted_at).not_to be_nil
      end
    end

    context "as regular user" do
      it "returns forbidden" do
        delete "/api/movies/#{movie.id}", headers: user_headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
