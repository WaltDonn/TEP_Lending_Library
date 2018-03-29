require 'test_helper'

class ComponentCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @component_category = component_categories(:one)
  end

  test "should get index" do
    get component_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_component_category_url
    assert_response :success
  end

  test "should create component_category" do
    assert_difference('ComponentCategory.count') do
      post component_categories_url, params: { component_category: { description: @component_category.description, name: @component_category.name } }
    end

    assert_redirected_to component_category_url(ComponentCategory.last)
  end

  test "should show component_category" do
    get component_category_url(@component_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_component_category_url(@component_category)
    assert_response :success
  end

  test "should update component_category" do
    patch component_category_url(@component_category), params: { component_category: { description: @component_category.description, name: @component_category.name } }
    assert_redirected_to component_category_url(@component_category)
  end

  test "should destroy component_category" do
    assert_difference('ComponentCategory.count', -1) do
      delete component_category_url(@component_category)
    end

    assert_redirected_to component_categories_url
  end
end
