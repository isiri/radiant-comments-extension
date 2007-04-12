#require 'page_extender'

class CommentsExtension < Radiant::Extension
  version "0.0.1"
  description "Ads comment functionality to pages."
  url "http://dev.radiantcms.org/radiant/browser/trunk/extensions/examples/hello_tag/"
  
  define_routes do |map|
    map.resources :comments, :path_prefix => "/pages/:page_id", :controller => "comments"
    map.with_options :controller => 'admin/comments' do |comments|
      comments.resources :comments, :path_prefix => "/admin", :name_prefix => "admin_"
      # Remove these routes when done with scaffolding: 
      comments.admin_comments 'admin/comments/:action/:id'
      comments.admin_page_comments 'admin/pages/:page_id/comments;:action'
      comments.admin_page_comment 'admin/pages/:page_id/comments/:id;:action'
    end
  end
  
  
  def activate
    # The reference to HelloTag causes it to be automatically loaded
    # from lib/hello_tag.rb
    # Page.send :include, CommentsExtensions
    Page.send :include, CommentTags
    
    admin.tabs.add "Comments", "/admin/comments", :after => "Pages", :visibility => [:all]
    # Page.send :include, PageExtender
    # require File.dirname(__FILE__) + '/app/models/page'
    CommentTags
    
    Page.class_eval do
      has_many :comments
    end
    
  end
end