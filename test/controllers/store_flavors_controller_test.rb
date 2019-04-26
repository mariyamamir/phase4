require 'test_helper'

class StoreFlavorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @store_flavor = store_flavors(:one)
  end

  test "should get index" do
    get store_flavors_url
    assert_response :success
  end

  test "should get new" do
    get new_store_flavor_url
    assert_response :success
  end

  test "should create store_flavor" do
    assert_difference('StoreFlavor.count') do
      post store_flavors_url, params: { store_flavor: { flavor_id: @store_flavor.flavor_id, store_id: @store_flavor.store_id } }
    end

    assert_redirected_to store_flavor_url(StoreFlavor.last)
  end

  test "should show store_flavor" do
    get store_flavor_url(@store_flavor)
    assert_response :success
  end

  test "should get edit" do
    get edit_store_flavor_url(@store_flavor)
    assert_response :success
  end

  test "should update store_flavor" do
    patch store_flavor_url(@store_flavor), params: { store_flavor: { flavor_id: @store_flavor.flavor_id, store_id: @store_flavor.store_id } }
    assert_redirected_to store_flavor_url(@store_flavor)
  end

  test "should destroy store_flavor" do
    assert_difference('StoreFlavor.count', -1) do
      delete store_flavor_url(@store_flavor)
    end

    assert_redirected_to store_flavors_url
  end
end
