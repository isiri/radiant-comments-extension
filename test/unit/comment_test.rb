require 'test/unit'
require File.dirname(__FILE__) + '/../test_helper'

class CommentTest < Test::Unit::TestCase
  # Replace this with your real tests.
  
  def test_new_record_should_handle_http
    comment = Comment.new
    assert_equal "http://", comment.author_url
  end
  
  def test_should_remove_http_if_blank
    comment = Comment.build(:author => "Foo Bar", :author_email => "foo@bar.com", :content => "This is a comment")
    assert_valid comment
  end
  
end
