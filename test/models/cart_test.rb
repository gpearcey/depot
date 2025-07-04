require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "should add unique products to cart" do
    cart = Cart.create
    pragprog_book = products(:pragprog)
    product_one = products(:one)
    
    cart.add_product(pragprog_book).save!
    cart.add_product(product_one).save!
    
    assert_equal 2, cart.line_items.size
    assert_equal pragprog_book, cart.line_items[0].product
    assert_equal product_one, cart.line_items[1].product
  end
  
  test "should increment quantity for duplicate products" do
    cart = Cart.create
    pragprog_book = products(:pragprog)
    
    # Add the same product twice
    cart.add_product(pragprog_book).save!
    cart.add_product(pragprog_book).save!
    
    # Should have only 1 line item but with quantity 2
    assert_equal 1, cart.line_items.size
    assert_equal 2, cart.line_items[0].quantity
    assert_equal pragprog_book, cart.line_items[0].product
  end
  
  test "should capture product price when adding to cart" do
    cart = Cart.create
    pragprog_book = products(:pragprog)
    
    line_item = cart.add_product(pragprog_book)
    line_item.save!
    
    assert_equal pragprog_book.price, line_item.price
  end
end
