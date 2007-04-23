class CommentsController < ApplicationController
  
  no_login_required
  
  def create
    
    @page = Page.find(params[:page_id])
    @comment = @page.comments.build(params[:comment])
    ResponseCache.instance.expire_response(@page.url)
    @comment.save
    
    comment_url = @page.url + '#comment_' + @comment.id.to_s
    redirect_to comment_url
  end
  
end