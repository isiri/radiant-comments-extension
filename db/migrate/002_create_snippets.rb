class CreateSnippets < ActiveRecord::Migration
  def self.up
    
    # This code _WILL_ override snippets with the name comments, comment and comment_form
    # if they exists.
    
    # Comments snippet
    Snippet.new do |s|
      s.name = "comments"
      s.content = <<CONTENT
<r:if_comments>
  <h2>Comments</h2>
  <r:comments:each>
    <r:snippet name="comment" />
  </r:comments:each>
</r:if_comments>
<r:snippet name="comment_form" />
CONTENT
    end.save
    
    # Comment snippet
    Snippet.new do |s|
      s.name = "comment"
      s.content = <<CONTENT
<div class="comment">
  <span class="number"><r:index />.</span>
  <span class="by_line">
    <r:author_link /> wrote:
  </span>
  <div class="message">
    <r:content />
  </div>
</div>
CONTENT
    end.save
    
    # Comment_form snippet
    Snippet.new do |s|
      s.name = "comment_form"
      s.content = <<CONTENT
<r:if_comments_enabled>
  <r:comments:form>
    <h2>Post a Comment</h2>
    <p>
      <label>Name</label>
      <r:author_field class="textbox" />
    </p>
    <p>
      <label>E-mail <small>(not shown)</small></label>
      <r:author_email_field class="textbox" />
    </p>
    <p>
      <label>Website</label>
      <r:author_url_field class="textbox" />
    </p>
    <p>
      <label>Text Filter</label>
      <r:text_filter_field />
    </p>
    <p>
      <label>Message</label>
      <r:content_field rows="9" cols="40" />
    </p>
    <div class="buttons">
      <input type="submit" value="Post Comment" />
    </div>
  </r:comments:form>
</r:if_comments_enabled>
CONTENT
    end.save
  end
  
  def self.down
    
    Snippet.find_by_name("comments").destroy
    Snippet.find_by_name("comment").destroy
    Snippet.find_by_name("comment_form").destroy
   
  end
end