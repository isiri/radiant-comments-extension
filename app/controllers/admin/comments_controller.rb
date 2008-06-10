class Admin::CommentsController < ApplicationController
  
  def index
    @page = Page.find(params[:page_id]) if params[:page_id]
    @comments = @page.nil? ?
      Comment.paginate(:page => params[:page]) :
      @page.comments.paginate(:page => params[:page])
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    announce_comment_removed
    ResponseCache.instance.expire_response(@comment.page.url)
    redirect_to admin_page_comments_path(@comment.page)
  end
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  def update
    @comment = Comment.find(params[:id])
    begin
      @comment.update_attributes(params[:comment])
      flash[:notice] = "Comment Saved"
      redirect_to :action => :index
    rescue Exception => e
      flash[:notice] = "There was an error saving the comment"
    end
  end
  
  def enable
    
    @page = Page.find(params[:page_id])
    
    @page.update_attribute(:enable_comments, 1)
    
    flash[:notice] = "Comments have been enabled for #{@page.title}"
     
    redirect_to page_index_path
  end
  
  protected
  
    def announce_comment_removed
      flash[:notice] = "The comment was successfully removed from the site."
    end
  
end