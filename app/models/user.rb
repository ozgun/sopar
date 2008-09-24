class User < ActiveRecord::Base
  # Filters
  before_save :encrypt_password
  before_destroy :dont_destroy_admin

  #NOTES: I've used some codes from "restful-authentication" plugin. 
  #If you prefer a better authentication I suggest using restful-authentication.
  #http://github.com/technoweenie/restful-authentication/tree/master

  #Constants
  EMAIL_REGEX = /\A[A-Z0-9\._%-]+@([A-Z0-9-]+\.)+[A-Z]{2,4}\z/i
  USERNAME_REGEX = /^[a-z0-9_]+$/i

  #Virtaul attributes
  attr_accessor :password, :new_password

  #Allow only following attributes updated or created with mass-updates
  attr_accessible :username, :email, :first_name, :last_name, :biography, 
                  :password, :password_confirmation, :website

  # Validations
  validates_presence_of :username, :email
  validates_length_of :username, :within => 4..40
  validates_format_of :username, :with => USERNAME_REGEX
  validates_uniqueness_of  :username, :email, :case_sensitive => :false
  with_options :if => :password_required? do |user|
    user.validates_presence_of :password
    user.validates_length_of :password, :within => 4..100
    user.validates_presence_of :password_confirmation
    user.validates_confirmation_of :password
  end

  def dont_destroy_admin
    raise "Error! Can't delete admin!" if self.id == 1
  end
  
  # Called from controller
  def self.login(username, password)
    user = find :first, :conditions => ["username = ? AND deactivated = 0", username ]
    user && user.authenticated?(password) && user.update_last_logged_in_at ? user : nil
  end


  #
  # Update last login date
  #
  def update_last_logged_in_at
     self.last_logged_in_at = Time.now
     self.save
  end
  
  #
  # De-Activate user
  #
  def deactivate_account
    self.update_attribute('deactivated', 1)
  end

  #
  # Set necessary fields for auto login.
  #
  def remember_me
    self.remember_token_expires_at = 52.weeks.from_now
    self.remember_token = rand_key(self.username)
    self.save(false)
  end

  #
  # Reset necessary fields to disable auto login.
  #
  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token = nil
    self.save(false)
  end

  #
  # Encrypts some data with the salt.
  #
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  #
  # Encrypts the password with the user salt
  #
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def fullname
    [self.first_name, self.last_name].join(' ')
  end

  def fullname=(fullname)
    self.first_name, self.last_name = fullname.strip.split(' ', 2)
    self.last_name = " " if self.last_name.nil?
  end

  def update_password(password, password_confirmation)
    if password.blank? or password_confirmation.blank?
      self.errors.add("password", "can't be blank!")
      return false
    else
      self.update_attributes!(:password => password, :password_confirmation => password_confirmation)
      return true
    end
  rescue
    return false
  end

  def latest_article
    self.articles.find :first, :conditions => ["published=1"], :order => "created_at DESC"
  end
  
  def latest_articles
    self.articles.find :all, :conditions => ["published=1"], :order => "created_at DESC", :limit => 5
  end
  
  protected

  def encrypt_password
      return if password.blank?
      self.salt = rand_key(self.username) if new_record?
      self.crypted_password = encrypt(password)
  end

  def password_required?
    logger.debug(self.inspect)
    crypted_password.nil? || !password.blank?
  end

  def rand_key(username)
    Digest::SHA1.hexdigest("--#{Time.now.to_s.split(//).sort_by {rand}.join}--#{username}--")
  end

end
