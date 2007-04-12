class ApplicationController < ActionController::Base
  
  private
  
  def set_javascripts_and_stylesheets
    super
    @javascripts << "tiny_mce/tiny_mce"
  end
  
end