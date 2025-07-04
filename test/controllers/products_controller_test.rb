require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @title = "The Great Book #{rand(1000)}"
  end

  test "should get index" do
    get products_url
    assert_response :success
    assert_select "nav a", minimum: 4
    assert_select "main ul li", 9
    assert_select "h1", "Products"
    assert_select "div", /\$[,\d]+\.\d\d/
  end

  test "should get new" do
    get new_product_url
    assert_response :success
  end

  test "should create product" do
    assert_difference("Product.count") do
      post products_url, params: { product: { description: @product.description, image: file_fixture_upload("lorem.jpg", "image/jpeg"), price: @product.price, title: @title } }
    end

    assert_redirected_to product_url(Product.last)
  end

  test "should show product" do
    get product_url(@product)
    assert_response :success
  end

  test "should get edit" do
    get edit_product_url(@product)
    assert_response :success
  end

  test "should update product" do
    patch product_url(@product), params: { product: { description: @product.description, image: file_fixture_upload("lorem.jpg", "image/jpeg"), price: @product.price, title: @title } }
    assert_redirected_to product_url(@product)
  end

  test "should destroy product" do
    # Try to delete a product that has line items - should fail and redirect
    delete product_url(products(:two))
    assert_redirected_to products_url
    assert_match /Cannot delete product/, flash[:alert]
    assert Product.exists?(products(:two).id)
    
    # Delete a product without line items - should succeed
    assert_difference("Product.count", -1) do
      delete product_url(@product)
    end

    assert_redirected_to products_url
  end
end
