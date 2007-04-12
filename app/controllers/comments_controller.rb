class CommentsController < ApplicationController
  
  def index
    render :text => params.inspect
  end
  
  def create
    
    @page = Page.find(params[:page_id])
    @comment = @page.comments.build(params[:comment])
    
    ResponseCache.instance.expire_response(@page.url)
    
    if @comment.save
      flash[:notice] = "Thank you for your comment"
    else
      flash[:notice] = "Your comment was not saved"
    end
    redirect_to @page.url
  end
  
end