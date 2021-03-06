class PostsController < ApplicationController
  before_filter :prepare_hidden_styles, :only => 'show'

  def index
    @tag = params[:tag]
    # hack to allow tags with (one, for now) dot
    if params[:format] && !%w'html atom'.include?(params[:format])
      @tag = "#@tag.#{params[:format]}"
      params[:format] = 'html'
    end
    @posts = Post.find_recent(:tag => @tag, :include => :tags)

    respond_to do |format|
      format.html { render '_error_404', :status => 404 if !@tag.blank? && @posts.empty? }
      format.atom { render :layout => false }
    end
  end

  def show
    @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:approved_comments, :tags]}))
    @comment = Comment.new
  end
end
