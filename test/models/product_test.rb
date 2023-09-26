require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test "should be valid" do
    product = Product.new(
      name: "nahuel",
      description: "lopez",
      price: 2222
    )
    assert product.valid?
  end

  test "name should be present" do
    product = Product.new(
      name: "",
      description: "lopez",
      price: 2222
    )
    assert_not product.valid?
    assert_includes product.errors[:name], "can't be blank"
  end

  test "description should be present" do
    product = Product.new(
      name: "nahuel",
      description: "",
      price: 2222
    )
    assert_not product.valid?
    assert_includes product.errors[:description], "can't be blank"
  end

  test "price should be a number" do
    product = Product.new(
      name: "nahuel",
      description: "lopez",
      price: "invalid_price"
    )
    assert_not product.valid?
    assert_includes product.errors[:price], "is not a number"
  end

  test "price should be greater than or equal to 0" do
    product = Product.new(
      name: "nahuel",
      description: "lopez",
      price: -100
    )
    assert_not product.valid?
    assert_includes product.errors[:price], "must be greater than or equal to 0"
  end

  test "name should not exceed 255 characters" do
    long_name = "a" * 256
    product = Product.new(
      name: long_name,
      description: "lopez",
      price: 2222
    )
    assert_not product.valid?
    assert_includes product.errors[:name], "is too long (maximum is 255 characters)"
  end

end
