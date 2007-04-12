module CommentTags
  include Radiant::Taggable
  
  desc "Provides tags and behaviors to support comments in Radiant."
  
  desc %{}
  tag "if_enable_comments" do |tag|
    tag.expand if (tag.locals.page.enable_comments?)
  end
  
  desc %{}
  tag "if_comments" do |tag|
    tag.expand if tag.locals.page.has_comments?
  end
  
  desc %{ All comment-related tags live inside this one. }
  tag "comment" do |tag|
    tag.expand
  end
  
  desc %{}
  tag "comment:each" do |tag|
    comments = tag.locals.page.comments
    result = []
    comments.each do |comment|
      tag.locals.comment = comment
      result << tag.expand
    end
    result
  end
  
  tag "comment:field" do |tag|
    tag.expand
  end
  
  %w(author author_email author_url content content_html).each do |field|
    desc %{ Print the value of the #{field} field for this comment. }
    tag "comment:field:#{field}" do |tag|
      options = tag.attr.dup
      #options.inspect
      tag.locals.comment.send(field)
    end
  end
  
  desc %{}
  tag "comment:form" do |tag|
    @tag_attr = { :class => "comment_form" }.update( tag.attr.symbolize_keys )
    results = %Q{
      <form action="/pages/#{tag.locals.page.id}/comments" method="post" id="comment_form">
      <fieldset>
      Comment Form:
      #{tag.expand}
      </fieldset>
      </form>
    }
  end
  
  #tag "comment:text_field" do |tag|
  #  attrs = tag.attr.symbolize_keys
  #  # text_field_tag(attrs[:name], attrs[:value]).inspect
  #  %{<input type="text" name="#{attrs[:name]}" value="#{attrs[:value]}" />}
  #end
  
  %w(text password hidden).each do |type|
    desc %{Builds a #{type} form field for comments.}
    tag "comment:#{type}_field_tag" do |tag|
      attrs = tag.attr.symbolize_keys
      r = %{<input type="#{type}"}
      r << %{ id="comment_#{attrs[:name]}"}
      r << %{ name="comment[#{attrs[:name]}]"}
      r << %{ class="#{attrs[:class]}"} if attrs[:class]
      r << %{ value="#{attrs[:value]}" } if attrs[:value]
      r << %{ />}
       
    end
  end
  
  %w(submit reset).each do |type|
    desc %{Builds a #{type} form button for comments.}
    tag "comment:#{type}_tag" do |tag|
      attrs = tag.attr.symbolize_keys
      r = %{<input type="#{type}"}
      r << %{ id="#{attrs[:name]}"}
      r << %{ name="#{attrs[:name]}"}
      r << %{ class="#{attrs[:class]}"} if attrs[:class]
      r << %{ value="#{attrs[:value]}" } if attrs[:value]
      r << %{ />}
    end
  end
  
  desc %{Builds a text_area form field for comments.}
  tag "comment:text_area_tag" do |tag|
    attrs = tag.attr.symbolize_keys
    r = %{<textarea}
    r << %{ id="comment_#{attrs[:name]}"}
    r << %{ name="comment[#{attrs[:name]}]"}
    r << %{ class="#{attrs[:class]}"} if attrs[:class]
    r << %{ rows="#{attrs[:rows]}"} if attrs[:rows]
    r << %{ cols="#{attrs[:cols]}"} if attrs[:cols]
    r << %{>}
    r << attrs[:content] if attrs[:content]
    r << %{</textarea>}
  end
  
  #file submit reset checkbox radio
  
  
  desc %{}
  tag "comments" do |tag|
    comments = tag.locals.page.comments
    comments.inspect
  end
  
  
  protected
  
end