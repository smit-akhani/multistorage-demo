class Product < ApplicationRecord
  has_many_attached :images
  has_one_attached :doc
end
