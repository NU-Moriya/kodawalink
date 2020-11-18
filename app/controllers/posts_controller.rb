class PostsController < ApplicationController
  before_action :authenticate_user!

  def create

    commitment = Commitment.find(params["post"]["commitment_id"])
    post = Post.new(post_params)
    post.user_id = current_user.id
    post.commitment_id = commitment.id
    if post.save
      redirect_to commitment_path(commitment), notice: "こだわりを投稿しました"
    end
  end

  def show
    @post = Post.find(params[:id])
    @commitment = @post.commitment_id
    @comment = PostComment.new
    @comments = @post.post_comments

  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post)
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @commitment = @post.commitment_id
    @post.destroy
    redirect_to controller: :commitments, action: :show, id: @commitment
  end

  def search
    if params[:content].empty?
    else
      @content = params[:content]
      @posts = Post.search_for(@content, params[:commitment_id].to_i)
    end
    @commitment = Commitment.find(params[:commitment_id])
  end

  def ranking
   #postに関連するbravoを引っ張ってくる。whereでその範囲を絞って、post_idをグループ化。その後ランキング化
    @posts= Post.joins(:bravos).where(commitment_id: params[:commitment_id]).group(:post_id).order('count(user_id) desc').limit(5)
  end

  private
  def post_params
    params.require(:post).permit(:content, :image, :commitment_id)
  end

end
