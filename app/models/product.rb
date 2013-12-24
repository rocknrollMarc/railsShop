class Product < ActiveRecord::Base
  has_many :line_items
  has_many :orders, through: :line_items

  validates :title, :description, :image_url, presence: true
  validates :price, :numericality => {:less_than_or_equal_to =>    1000}

  validates :title, length: {minimum: 10}
  validates :title, uniqueness: true
  validates :image_url, :uniqueness => true, allow_blank: true, format: {
    with:    %r{\.(gif|jpg|png)\Z}i,
    message: 'must be a URL for GIF, JPG or PNG image.'
  }
  def self.latest
    Product.order(:updated_at).last
  end

  private

 # ensure that there are no line items referencing this product
  def ensure_not_referenced_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'Line Items present')
      return false
    end
  end
end
