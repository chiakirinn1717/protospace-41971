class PrototypesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  def index
    @prototypes = Prototype.includes(:user).all
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = Comment.where(prototype_id: @prototype.id)
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to "/"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  #以下ログインが必要

  def new
    @prototype = Prototype.new
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless user_signed_in? && current_user.id == @prototype.user_id
      redirect_to "/"
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to "/"
  end

  private 
  
  def prototype_params
    params.require(:prototype).permit(:title,:catch_copy,:concept,:image).merge(user_id: current_user.id)
  end

end
