require File.dirname(__FILE__) + '/../test_helper'

class CustomTagsExtensionTest < Test::Unit::TestCase
  
  # Replace this with your real tests.
  def test_this_extension
    flunk
  end
  
  def test_initialization
    assert_equal RADIANT_ROOT + '/vendor/extensions/custom_tags', CustomTagsExtension.root
    assert_equal 'Custom Tags', CustomTagsExtension.extension_name
  end
  
end
