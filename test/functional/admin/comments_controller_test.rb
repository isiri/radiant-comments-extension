require File.dirname(__FILE__) + '/../../test_helper'

# Re-raise errors caught by the controller.
Admin::CommentsController.class_eval { def rescue_action(e) raise e end }

class Admin::CommentsControllerTest < Test::Unit::TestCase
  def setup
    @controller = Admin::CommentsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_enable_comments
    page = Page.new do |p|
      p.title = "FOO"
      p.slug = "foo"
      p.breadcrumb = "FOO"
      p.class_name = "Page"
    end
    page.save

    assert !page.enable_comments

    post :enable, :page_id => page.id

    assert_response :redirect

    page = Page.find_by_title("FOO")

    assert page.enable_comments
  end
  
end

