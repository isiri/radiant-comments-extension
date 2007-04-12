module CommentsExtensions
  include Radiant::Taggable
  
  tag "hello" do |tag|
    "Hello #{tag.attr['name'] || 'world'}!"
  end
end