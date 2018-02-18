require 'test_helper'

class ItemCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item_category = item_categories(:one)
  end

  test "should get index" do
    get item_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_item_category_url
    assert_response :success
  end

  test "should create item_category" do
    assert_difference('ItemCategory.count') do
      post item_categories_url, params: { item_category: { amount_available: @item_category.amount_available, description: @item_category.description, inventory_level: @item_category.inventory_level, name: @item_category.name } }
    end

    assert_redirected_to item_category_url(ItemCategory.last)
  end

  test "should show item_category" do
    get item_category_url(@item_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_category_url(@item_category)
    assert_response :success
  end

  test "should update item_category" do
    patch item_category_url(@item_category), params: { item_category: { amount_available: @item_category.amount_available, description: @item_category.description, inventory_level: @item_category.inventory_level, name: @item_category.name } }
    assert_redirected_to item_category_url(@item_category)
  end

  test "should destroy item_category" do
    assert_difference('ItemCategory.count', -1) do
      delete item_category_url(@item_category)
    end

    assert_redirected_to item_categories_url
  end
end
