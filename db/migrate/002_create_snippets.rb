class CreateSnippets < ActiveRecord::Migration
  def self.up
    
    # This code _WILL_ override snippets with the name comments, comment and comment_form
    # if they exists.
    
    # Comments snippet
    Snippet.new do |s|
      s.name = "comments"
      s.content = <<CONTENT
<r:if_comments>
  <div class="comments">
    <h2>Comments</h2>
    <r:comment:each>
      <r:snippet name="comment" />
    </r:comment:each>
  </div>
</r:if_comments>
<r:snippet name="comment_form" />
CONTENT
    end.save

    # Comment snippet
    Snippet.new do |s|
      s.name = "comment"
      s.content = <<CONTENT
<div class="comment">
  <p class="author"><r:comment:field:author /> said on <r:comment:date />:</p>
  <div class="content_html"><r:comment:field:content_html /></div>
</div>
CONTENT
    end.save

    # Comment_form snippet
    Snippet.new do |s|
      s.name = "comment_form"
      s.content = <<CONTENT
<r:page>
  <r:if_enable_comments>
    <r:comment:form>
      <h3>Post a comment</h3>
      <p><label for="comment[author]">Your Name</label><br />
      <r:comment:text_field_tag name="author" id="author" class="title required" /></p>

      <p><label for="comment[author_email]">Your Email Address</label> (required, but not displayed)<br />
      <r:comment:text_field_tag name="author_email" class="title required validate-email" /></p>

      <p><label for="comment[author_url]">Your Web Address</label> (optional)<br />
      <r:comment:text_field_tag name="author_url" class="regular validate-url" /></p>

      <p><label for="comment[content]">Your Comment</label><br />
      <r:comment:text_area_tag name="content" class="regular required" rows="9" cols="40" /></p>

      <r:comment:hidden_field_tag name="filter_id" value="Textile" />
      <r:comment:submit_tag name="submit" value="Save Comment" />

    </r:comment:form>
  </r:if_enable_comments>
</r:page>
CONTENT
    end.save
  end
  
  def self.down
    
    Snippet.find_by_name("comments").destroy
    Snippet.find_by_name("comment").destroy
    Snippet.find_by_name("comment_form").destroy
   
  end
end