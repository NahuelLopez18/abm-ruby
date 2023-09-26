require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "should create product with valid price on day 5" do
    travel_to Time.zone.local(2023, 9, 5, 12, 0, 0) do
      post products_url, params: { product: { name: "Test Product", description: "Test Description", price: 4000 } }
    end
    assert_redirected_to product_path(assigns(:product))
    assert_equal "Producto creado exitosamente.", flash[:notice]
  end

  test "should create product with valid price on day 20" do
    travel_to Time.zone.local(2023, 9, 20, 12, 0, 0) do
      post products_url, params: { product: { name: "Test Product", description: "Test Description", price: 6000 } }
    end
    assert_redirected_to product_path(assigns(:product))
    assert_equal "Producto creado exitosamente.", flash[:notice]
  end

  test "should not create product with invalid price on day 5" do
    travel_to Time.zone.local(2023, 9, 5, 12, 0, 0) do
      post products_url, params: { product: { name: "Test Product", description: "Test Description", price: 6000 } }
    end
    assert_response :success
    assert_template :new
    assert_includes assigns(:product).errors[:price], "Debe ser menor o igual a 5000 en los primeros 15 días del mes"
  end

  test "should not create product with invalid price on day 20" do
    travel_to Time.zone.local(2023, 9, 20, 12, 0, 0) do
      post products_url, params: { product: { name: "Test Product", description: "Test Description", price: 4000 } }
    end
    assert_response :success
    assert_template :new
    assert_includes assigns(:product).errors[:price], "Debe ser mayor a 5000 después del día 15 del mes"
  end
end
