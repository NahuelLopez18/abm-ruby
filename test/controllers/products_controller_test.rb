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

  def assert_errors(response, field, message_error)
    assert_response :unprocessable_entity
    response_json = JSON.parse(response.body)
    errors = response_json[field]
    puts "Error #{field}: #{message_error}" 
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
    message_error = I18n.t("errors.messages.price_should_be_less_or_equal_in_first_days_of_month", count: 5000, day: 15)
    post products_url, params: product_params("Test Product", "Test Description", 6000), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'price', message_error)
  end

  test "should not create product with invalid price on day 20" do
    message_error = I18n.t("errors.messages.price_should_be_greater_after_day", count: 5000, day: 15)
    travel_to Time.zone.local(2023, 9, 20, 12, 0, 0)
    post products_url, params: product_params("Test Product", "Test Description", 4000), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'price', message_error)
  end
  
  test "price should be a number" do
    message_error = I18n.t("errors.messages.not_a_number")
    post products_url, params: product_params("Test Product", "Test Description", "invalid_price"), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'price', message_error)
  end
  
  test "price should be greater than or equal to 0" do
    message_error = I18n.t("errors.messages.greater_than_or_equal_to", count: 0)
    post products_url, params: product_params("Test Product", "Test Description", -100), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'price', message_error)
  end

  test "name should be present" do
    message_error = I18n.t("errors.messages.blank")
    post products_url, params: product_params("", "Test Description", 2222), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'name', message_error)
  end
  
  test "name should not exceed 255 characters" do
    message_error = I18n.t("errors.messages.too_long", count: 255)
    long_name = "a" * 256
    post products_url, params: product_params(long_name, "Test Description", 2222), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'name', message_error)
  end

  test "name should have a minimum of 3 characters" do
    message_error = I18n.t("errors.messages.too_short", count: 3)
    post products_url, params: product_params("Test Product", "ab", 2222), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'name', message_error)
  end

  test "description should be present" do
    message_error = I18n.t("errors.messages.blank")
    post products_url, params: product_params("Test Product", "", 2222), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'description', message_error)
  end

  test "description should not exceed 255 characters" do
    message_error = I18n.t("errors.messages.too_long", count: 255)
    long_name = "a" * 256
    post products_url, params: product_params(long_name, "Test Description", 2222), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'description', message_error)
  end

  test "description should have a minimum of 3 characters" do
    message_error = I18n.t("errors.messages.too_short", count: 3)
    post products_url, params: product_params("Test Product", "ab", 2222), headers: { 'Accept' => 'application/json' }
    assert_errors(response, 'description', message_error)
  end
end