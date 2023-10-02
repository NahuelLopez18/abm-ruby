class Product < ApplicationRecord
  validates :name, presence: true, length: { maximum: 255, minimum: 3 }
  validates :description, presence: true, length: { maximum: 255, minimum: 3 }
    validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

    validate :price_within_limit_based_on_day

    def price_within_limit_based_on_day
      day_of_month = Time.now.day
    
      if price.present?
        if day_of_month >= 1 && day_of_month <= 15
          if price > 5000
            errors.add(:price, "Debe ser menor o igual a 5000 en los primeros 15 días del mes")
          end
        else
          if price <= 5000
            errors.add(:price, "Debe ser mayor a 5000 después del día 15 del mes")
          end
        end
      else
        errors.add(:price, "Debe tener un valor válido")
      end
    end    
end
