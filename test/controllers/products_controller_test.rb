require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest

  test "should create product with valid price on day 5" do
    travel_to Time.zone.local(2023, 9, 5, 12, 0, 0) do
      post products_url, params: { product: { name: "Test Product", description: "Test Description", price: 4000 } }, headers: { 'Accept' => 'application/json' }
    end
    assert_response :success
    response_body = JSON.parse(response.body)
    puts "Success: #{response_body}"
  end
  
  test "should create product with valid price on day 20" do
    travel_to Time.zone.local(2023, 9, 20, 12, 0, 0) do
      post products_url, params: { product: { name: "Test Product", description: "Test Description", price: 6000 } }, headers: { 'Accept' => 'application/json' }
    end
    assert_response :success
    response_body = JSON.parse(response.body)
    puts "Success: #{response_body}"
  end
  
  
  test "should not create product with invalid price on day 5" do
    travel_to Time.zone.local(2023, 9, 5, 12, 0, 0) do
      post products_url, params: { product: { name: "Test Product", description: "Test Description", price: 6000 } }, headers: { 'Accept' => 'application/json' }
    end
    assert_response :unprocessable_entity
    response_json = JSON.parse(response.body)
    response_json.each do |field, errors|
      puts "Error #{field}: #{errors.join(', ')}" if errors.present?
    end    
  end  

  test "should not create product with invalid price on day 20" do
    travel_to Time.zone.local(2023, 9, 20, 12, 0, 0) do
      post products_url, params: { product: { name: "Test Product", description: "Test Description", price: 4000 } }, headers: { 'Accept' => 'application/json' }
    end
    assert_response :unprocessable_entity
    response_json = JSON.parse(response.body)
    response_json.each do |field, errors|
      puts "Error #{field}: #{errors.join(', ')}" if errors.present?
    end    
  end
end