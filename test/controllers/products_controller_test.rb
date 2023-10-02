require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  def setup
    travel_to Time.zone.local(2023, 9, 5, 12, 0, 0)
  end
  
  def product_params(name, description, price)
    {
      product: {
        name: name,
        description: description,
        price: price
      }
    }
  end

  def assert_errors(response, field)
    assert_response :unprocessable_entity
    response_json = JSON.parse(response.body)
    errors = response_json[field]
    puts "Error #{field}: #{errors.join(', ')}" if errors.present?
  end

  test "should create product with valid price on day 5" do
    post products_url, params: product_params("Test Product", "Test Description", 4000), headers: { 'Accept' => 'application/json' }
    assert_response :success
    response_body = JSON.parse(response.body)
    puts "Success: #{response_body}"
  end

  test "should create product with valid price on day 20" do
    travel_to Time.zone.local(2023, 9, 20, 12, 0, 0)
    post products_url, params: product_params("Test Product", "Test Description", 6000), headers: { 'Accept' => 'application/json' }
    assert_response :success
    response_body = JSON.parse(response.body)
    puts "Success: #{response_body}"
  end

  test "should not create product with invalid price on day 5" do
    post products_url, params: product_params("Test Product", "Test Description", 6000), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'price')
  end

  test "should not create product with invalid price on day 20" do
    travel_to Time.zone.local(2023, 9, 20, 12, 0, 0)
    post products_url, params: product_params("Test Product", "Test Description", 4000), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'price')
  end

  test "name should be present" do
    post products_url, params: product_params("", "Test Description", 2222), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'name')
  end

  test "description should be present" do
    post products_url, params: product_params("Test Product", "", 2222), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'description')
  end

  test "price should be a number" do
    post products_url, params: product_params("Test Product", "Test Description", "invalid_price"), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'price')
  end

  test "price should be greater than or equal to 0" do
    post products_url, params: product_params("Test Product", "Test Description", -100), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'price')
  end

  test "name should not exceed 255 characters" do
    long_name = "a" * 256
    post products_url, params: product_params(long_name, "Test Description", 2222), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'name')
  end
end