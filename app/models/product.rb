class Product < ApplicationRecord
    validates :name, presence: true, length: { maximum: 255 }
    validates :description, presence: true
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

    validate :price_within_limit_based_on_day

    def price_within_limit_based_on_day
      day_of_month = Time.now.day
  
      if day_of_month >= 1 && day_of_month <= 15
        if price > 5000
          errors.add(:price, "Debe ser menor o igual a 5000 en los primeros 15 días del mes")
        end
      else
        if price <= 5000
          errors.add(:price, "Debe ser mayor a 5000 después del día 15 del mes")
        end
      end
    end
end
