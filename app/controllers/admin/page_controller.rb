class Admin::PageController < ApplicationController
  uses_tiny_mce #(:options => {:mode => "exact", :elements => ["part[0][content]"]})
  
  def foo
    
  end
  
  def set_javascripts_and_stylesheets
    super
    @javascripts << "tiny_mce/tiny_mce.js"
  end
  
  
end