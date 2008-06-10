#require 'page_extender'
# require_dependency 'application'
require 'will_paginate'

class CommentsExtension < Radiant::Extension
  version "0.0.4"
  description "Adds blog-like comments and comment functionality to pages."
  url "http://svn.artofmission.com/svn/plugins/radiant/extensions/comments/"
  
  define_routes do |map|
    # Regular routes for comments
    map.resources :comments, :path_prefix => "/pages/:page_id", :controller => "comments" 
    map.with_options(:controller => 'admin/comments') do |comments| 
      # Admin routes for comments
      comments.resources :comments, :path_prefix => "/admin", :name_prefix => "admin_" 
      # This route allows us to nicely pull up comments for a particular page
      comments.admin_page_comments 'admin/pages/:page_id/comments;:action'  
      # This route pulls up a particular comment for a particular page
      comments.admin_page_comment 'admin/pages/:page_id/comments/:id;:action' 
      comments.enable_comments '/pages/:page_id/enable_comments', :action => "enable"
    end
  end
  
  def activate
    Page.send :include, CommentTags
    Comment
    
    Page.class_eval do
      has_many :comments, :dependent => :destroy
    end
    
    if admin.respond_to? :page
      admin.page.edit.add :parts_bottom, "edit_comments_enabled", :before => "edit_timestamp"
      admin.page.index.add :sitemap_head, "index_head_view_comments"
      admin.page.index.add :node_row, "index_view_comments"
    end
    
    admin.tabs.add "Comments", "/admin/comments", :visibility => [:developer, :admin]
  end
  
  def deactivate
  end
  
end