class Comment < ActiveRecord::Base
  belongs_to :page, :counter_cache => true

  validates_presence_of :author, :author_email, :content
  
  def initialize
    super
    self.author_url ||= "http://"
  end
  
  def self.per_page
    5
  end
  
  # Akismet Spam Filter
  # Marks a content item as spam unless it checks out with Akismet
  def is_spam?  
    # You'll need to get your own Akismet API key from www.akismet.com
    #@akismet = Akismet.new('123456789', 'http://myblog.wordpress.com') 
    
    return nil unless @akismet.verifyAPIKey
    
    return self.spam!(:exempt => true) if @akismet.commentCheck(
              self.author_ip,                   # remote IP
              self.user_agent,           # user agent
              self.referrer,             # http referer
              self.page.url,             # permalink
              'comment',                 # comment type
              self.author,               # author name
              self.author_email,         # author email
              self.author_url,           # author url
              self.content,              # comment text
              {})                        # other
  end

end