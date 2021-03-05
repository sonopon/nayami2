class PostsController < ApplicationController
  def index
    @posts = Post.includes(:user).order('created_at DESC')
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    if @post.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    if @post.update(post_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private
  def post_params
    params.require(:post).permit(:text).merge(user_id: current_user.id)
  end
end
