class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :director, :producer, :release_date, :created_at, :updated_at
end
