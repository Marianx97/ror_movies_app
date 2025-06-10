require 'rails_helper'

RSpec.describe Movie, type: :model do
  subject do
    described_class.new(
      title: 'Inception',
      description: 'A mind-bending thriller about dreams within dreams.',
      director: 'Christopher Nolan',
      producer: 'Emma Thomas',
      release_date: Date.new(2010, 7, 16)
    )
  end

  describe 'validations' do
    # Title
    it 'is invalid without a title' do
      subject.title = nil
      expect(subject).to be_invalid
      expect(subject.errors[:title]).to include("can't be blank")
    end

    it 'is invalid with a title longer than 50 characters' do
      subject.title = 'a' * 51
      expect(subject).to be_invalid
    end

    # Description
    it 'is invalid without a description' do
      subject.description = nil
      expect(subject).to be_invalid
    end

    it 'is invalid with description shorter than 10 characters' do
      subject.description = 'short'
      expect(subject).to be_invalid
    end

    it 'is invalid with description longer than 500 characters' do
      subject.description = 'a' * 501
      expect(subject).to be_invalid
    end

    # Director
    it 'is invalid without a director' do
      subject.director = nil
      expect(subject).to be_invalid
    end

    it 'is invalid with a director not matching name format' do
      subject.director = '123Invalid!'
      expect(subject).to be_invalid
    end

    # Producer
    it 'is invalid without a producer' do
      subject.producer = nil
      expect(subject).to be_invalid
    end

    it 'is invalid with a producer not matching name format' do
      subject.producer = '@ProducerName'
      expect(subject).to be_invalid
    end

    # Release date
    it 'is invalid with release_date before 1900' do
      subject.release_date = Date.new(1800, 1, 1)
      expect(subject).to be_invalid
    end

    it 'is invalid with release_date after current year' do
      subject.release_date = Date.new(Date.today.year + 1, 1, 1)
      expect(subject).to be_invalid
    end

    it 'is valid with correct attributes' do
      expect(subject).to be_valid
    end
  end
end
