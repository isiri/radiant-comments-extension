class Admin::CommentsController < ApplicationController
  before_filter :no_login_required, :only => [new]
  
  
  def index
    @page = Page.find(params[:page_id]) if params[:page_id]
    @comments = @page.nil? ? Comment.find(:all) : @page.comments 
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    announce_comment_removed
    ResponseCache.instance.expire_response(@comment.page.url)
    redirect_to admin_page_comments_path(@comment.page)
  end
  
  protected
  
    def announce_comment_removed
      flash[:notice] = "The comment was successfully removed from the site."
    end
  
end