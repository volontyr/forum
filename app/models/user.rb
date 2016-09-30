class User < ActiveRecord::Base
  attr_accessor :remember_token

  before_save :default_values
  before_create :confirmation_token

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
  			format: { with: VALID_EMAIL_REGEX },
  			uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }

  has_secure_password

  ROLE_OPTIONS = ['admin', 'moderator', 'user']
  validates :role, inclusion: { in: ROLE_OPTIONS }

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  
  def User.generate_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.generate_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    self.remember_token = nil
    update_attribute(:remember_digest, nil)
  end	

  def authenticated?(remember_token)
    BCrypt::Password.new(:remember_digest).password?(remember_token)
  end 

  def admin?
    self.role == "admin"
  end 

  def email_activate
    self.email_confirmed = true
    self.confirm_token = nil
    save!(:validate => false)
  end  

  private
    def default_values
      self.email = self.email.downcase
      self.role ||= "user"
      self.activated = true if self.role == "user"
      # self.activated = false if self.activated.nil?
    end

    def confirmation_token
      if self.confirm_token.blank?
        self.confirm_token = User.generate_token.to_s
      end
    end  

end
