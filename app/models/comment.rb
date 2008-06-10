class Comment < ActiveRecord::Base
  belongs_to :page, :counter_cache => true

  validates_presence_of :author, :author_email, :content
  # validates_as_ham
  validates_each(:content_html, { :on => :save }) do |record, attr_name, value|
    configuration = {:message => "I'm sorry, but our HAM gnomes think that comment tastes a little SPAMmy - they get confused pretty easily, but are usually triggered by things such as links to sites they don't like (unfortunately they don't like some sites that are frequently linked to but are good sites, like google.com). If you're not a robot or an evil SPAM king, you could remove the link, hide the link (by, say, writing the dots as 'dot'), or even try again later."}
    record.errors.add(attr_name, configuration[:message]) if record.is_spam?
  end
  
  def initialize
    super
    self.author_url ||= "http://"
  end
  
  def self.per_page
    5
  end
  
  def request=(request)
    self.author_ip = request.remote_ip
    self.user_agent = request.env['HTTP_USER_AGENT']
    self.referrer = request.env['HTTP_REFERER']
  end
  
  
  # TODO :: Move more of the code inside the model. For example the filter stuff.
  
  
  # Spam Filter
  # Marks a content item as spam unless it checks out with the spam filter
  def is_spam?  
    case Radiant::Config["comments.spam_filter"]
    when "Akismet"
    # You'll need to get your own Akismet API key from www.akismet.com
    @akismet = Akismet.new('key', 'webpage') 
    
    return nil unless @akismet.verifyAPIKey
    
    return self.spam!(:exempt => true) if @akismet.commentCheck(
              self.author_ip,            # remote IP
              self.user_agent,           # user agent
              self.referrer,             # http referer
              self.page.url,             # permalink
              'comment',                 # comment type
              self.author,               # author name
              self.author_email,         # author email
              self.author_url,           # author url
        self.content_html,         # comment text
              {})                        # other
    else
      return LinkSleeve.spam?(self.content_html)
    end
  end

end
