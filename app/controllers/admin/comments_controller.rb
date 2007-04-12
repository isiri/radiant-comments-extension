class Admin::CommentsController < ApplicationController
  scaffold :comment
  
  def index
    @page = Page.find(params[:page_id]) if params[:page_id]
    @comments = @page.nil? ? Comment.find(:all) : @page.comments 
    #render :text => @comments.inspect and return
  end
end