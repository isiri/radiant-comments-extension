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
    end
    
    comment.request = request
    
    # TODO :: Remove this ugly code and replace it with something nice...
    ####
    case comment.filter_id
      
    when "Textile"
      comment.content_html = TextileFilter.filter(comment.content)
    when "Markdown"
      comment.content_html = MarkdownFilter.filter(comment.content)
    when "SmartyPants"
      comment.content_html = SmartyPantsFilter.filter(comment.content)
    else
      comment.content_html = TextFilter.filter(comment.content)
    end
    ####
    
    
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