class Admin::CategoriesController < ApplicationController
  layout "admin"
  before_filter :login_required

  def index
    @category = Category.new
    @categories = Category.find :all, :order => "position"
  end
  
  def create
    @category = Category.new(params[:category])
    @category.save
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @category = Category.find(params[:id])
    @category.update_attributes(params[:category])
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @id = @category.id
    @category.destroy
    respond_to do |format|
      format.js
    end
  end

  def reposition
    @category = Category.new
    @categories = Category.find :all, :order => "position"
  end

  def order
    params[:my_list].each_with_index do |id, position|
      Category.update(id, :position => position) 
    end
    respond_to do |format|
      format.js
    end
  end

end
