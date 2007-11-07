module CommentTags
  include Radiant::Taggable
  
  desc %{
    Renders the contained elements if comments are enabled on the page. 
  }
  tag "if_comments_enabled" do |tag|
    tag.expand if (tag.locals.page.enable_comments?)
  end
  
  desc %{
    Renders the contained elements unless comments are enabled on the page. 
  }
  tag "unless_comments_enabled" do |tag|
    tag.expand unless (tag.locals.page.enable_comments?)
  end
  
  desc %{
    Renders the contained elements if the page has comments. 
  }
  tag "if_comments" do |tag|
    tag.expand if tag.locals.page.comments_count > 0
  end
  
  desc %{
    Renders the contained elements unless the page has comments. 
  }
  tag "unless_comments" do |tag|
    tag.expand unless tag.locals.page.comments_count > 0
  end
  
  desc %{ 
    Gives access to comment-related tags
  }
  tag "comments" do |tag|
    tag.expand
  end
  
  desc %{
    Renders the number of comments.
  }
  tag "comments:count" do |tag|
    tag.locals.page.comments_count
  end
  
  desc %{
    Cycles through each comment and renders the enclosed tags for each. 
  }
  tag "comments:each" do |tag|
    comments = tag.locals.page.comments
    result = []
    comments.each_with_index do |comment, index|
      tag.locals.comment = comment
      tag.locals.index = index
      result << tag.expand
    end
    result
  end
  
  desc %{
    Renders the comment number for the page.
  }
  tag "comments:each:index" do |tag|
    (tag.locals.index + 1)
  end
  
  %w(author author_url).each do |field|
    desc %{
      Render the value of the #{field} field for the comment.
    }
    tag "comments:each:#{field}" do |tag|
      tag.locals.comment.send(field)
    end
  end
  
  desc %{
    Render the content for the comment. If the html attribute is set to false
    it will not use the text filter to filter the HTML.
    
    <r:content filtered="true|false" />
  }
  tag "comments:each:content" do |tag|
    use_html = (tag.attr['filtered'] || 'true').downcase
    if use_html == 'true'
      tag.locals.comment.content_html
    else
      tag.locals.comment.content
    end
  end
  
  desc %{
    Renders the comment author's name as a link to his website. Or if he did
    not enter a URL, just the author's name.
        
    *Usage:*
    <pre><code><r:link [additional attributes...] /></code></pre>
  }
  tag "comments:each:author_link" do |tag|
    comment = tag.locals.comment
    unless comment.author_url.empty?
      attributes = html_attrs(tag.attr, :href => tag.render('author_url'))
      %{<a#{attributes}>#{tag.render('author')}</a>}
    else
      tag.render('author')
    end
  end
  
  desc %{
    Renders the date a comment was created. 
    
    *Usage:* 
    <pre><code><r:date [format="%A, %B %d, %Y"] /></code></pre>
  }
  tag 'comments:each:date' do |tag|
    comment = tag.locals.comment
    format = (tag.attr['format'] || '%A, %B %d, %Y')
    date = comment.created_at
    date.strftime(format)
  end
  
  desc %{
    Renders a set of form tags for posting a comment. 
    
    *Usage:*
    <r:comments:form>...</r:comment:form>
  }
  tag "comments:form" do |tag|
    attributes = html_attrs(tag.attr, :method => "post")
    %{<form action="/pages/#{tag.locals.page.id}/comments"#{attributes}>#{tag.expand}</form>}
  end
  
  %w(author author_email author_url).each do |field|
    desc %{
      Renders a form field for a comment's #{field} field.
    }
    tag "comments:form:#{field}_field" do |tag|
      attributes = html_attrs(tag.attr, :type=>"text", :name => "comment[#{field}]")
      %{<input#{attributes} />}
    end
  end
  
  desc %{
    Renders a textarea for a comment's message.
  }
  tag "comments:form:content_field" do |tag|
    attributes = html_attrs(tag.attr, :name => "comment[content]")
    %{<textarea#{attributes}>#{tag.expand}</textarea>}
  end
  
  desc %{
    Renders a combo box for the avaiable text filters.
  }
  tag "comments:form:text_filter_field" do |tag|
    attrs = tag.attr.symbolize_keys
    value = attrs.delete(:value)
    r = %{<select name="comment[filter_id]"#{html_attrs(attrs)}>}
    TextFilter.descendants.each do |filter| 
      r << %{<option value="#{filter.filter_name}"}
      r << %{ selected="selected"} if value == filter.filter_name
      r << %{>#{filter.filter_name}</option>}
    end
    r << %{</select>}
  end
  
  protected
  
    def html_attrs(attributes, unchangeable_attributes = {})
      attrs = attributes.symbolize_keys.update(unchangeable_attributes.symbolize_keys)
      attrs.inject([]) { |s, (k, v)| s << %{ #{k.to_s.downcase}="#{v}"} }.join
    end
  
end