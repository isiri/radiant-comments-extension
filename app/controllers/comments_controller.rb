class CommentsController < ApplicationController
  
  no_login_required
  
  def create
    
    page = Page.find(params[:page_id])
        
    comment = Comment.new do |c|
      c.author = params[:comment][:author]
      c.author_email = params[:comment][:author_email]
      c.author_url = params[:comment][:author_url]
      c.content = params[:comment][:content]
      c.filter_id = params[:comment][:filter_id]
      c.request = request
    end
    
    TextFilter.descendants.each do |filter| 
      comment.content_html = filter.filter(comment.content) if filter.filter_name == comment.filter_id    
    end
                  
    
    if !comment.is_spam? and page.comments << comment 
      ResponseCache.instance.expire_response(page.url)
    
      comment_url = page.url + '#comments'
      redirect_to comment_url
    else
      # TODO :: Handle exceptions correctly...
      raise "Errors: #{comment.errors.full_messages}"
    end
  end
  
end
