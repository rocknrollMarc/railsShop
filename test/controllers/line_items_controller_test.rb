test "One cart per session - The cart already exists" do
        assert_no_difference('Cart.count') do
      post :create, {product_id: products(:ruby).id}, {'cart_id' => '1'}
        end
        assert_equal "1", session[:cart_id]
        assert_redirected_to store_url
  end

  test "One cart per session - Create a new cart" do
    assert_difference('Cart.count', 1) do
      post :create, product_id: products(:ruby).id
    end
        assert_redirected_to store_url
    end

    test "Validate existing carts" do
        tests = [
      [:coffee, :o1_coffee,"108.00", 'cart1'],
      [:ruby,   :o1_ruby,  "149.85", 'cart1'],
      [:rails,  :o1_rails, "104.85", 'cart1'],
            [:coffee, :o2_coffee, "36.00", 'cart2'],
            [:ruby,   :o2_ruby,   "99.90", 'cart2']
    ].each do |t|

            # Note :o2_coffee doesn't exist
            # Validate t[1] exists in the database or POST created it!
            begin
                quantity = line_items(t[1]).quantity
            rescue
                quantity = 0
            end

            # Validate the products test database (fixture import)
            assert products(t[0])

            # Validate the carts test database (fixture import)
            assert carts(t[3])

            # Validate a product selection does not change the cart
          assert_no_difference('Cart.count') do
        post :create, {product_id: products(t[0]).id}, {'cart_id' => carts(t[3]).id.to_s}
          end

            # Validate the cart id set in the test database (fixture import) is the
            # cart id from post
            # ASSUMES @cart.id not altered in POST!!!! But this should never happen!
          assert_equal carts(t[3]).id, assigns["cart"].id

            # Validate choosing a product added 1 to its quantity
      assert_equal quantity+1, assigns["line_item"].quantity

            # Validate the product line_item total_price increases by the
            # product price - t[2] reflects the price increase
          assert_equal t[2], "%.2f" % assigns["line_item"].total_price
        end
  end
