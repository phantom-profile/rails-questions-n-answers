FactoryBot.define do
  factory :reward do
    title { "MyString" }
    question { create(:question) }
    image do
      ActiveStorage::Blob.create_and_upload!(
        io: File.open(Rails.root.join('spec/fixtures/files/image.jpeg'), 'rb'),
        filename: 'right image',
        content_type: 'image/jpeg'
      )
    end

    trait :invalid do
      title { "MyString" }
      question
      image do
        ActiveStorage::Blob.create_and_upload!(
          io: File.open(Rails.root.join('spec/fixtures/files/test_1.txt'), 'rb'),
          filename: 'invalid file',
          content_type: 'text/html'
        )
      end
    end
  end
end
