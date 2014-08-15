class Client < ActiveRecord::Base
  before_save {self.email = email.downcase }
  before_create :create_remember_token

  has_many :orders
  has_one :favorite

  def Client.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def Client.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, length: { minimum: 6, maximum: 50 }

  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(48))
  end

  def generate_password_confirmation_token!
    update_attribute(:confirmation_token, SecureRandom.urlsafe_base64(48))
  end

  def generate_confirm!
    update_attributes(:confirmation_token => SecureRandom.urlsafe_base64(48), :confirmation_token_sent_at => Time.zone.now)
  end

  States = {
    :inactive => 0,
    :active => 1,
    :douchebaggish => 2,
  }

  def self.delete_clients
    Client.where(state: 0).where("created_at < ?", 24.hours.ago).destroy_all
  end

  state_machine :state, :initial => :inactive,  :action => :bypass_validation do
    States.each do |name, value|
      state name, :value => value
    end

    event :activate do
      transition all => :active
    end

    event :mark_douchebaggish do
      transition all => :douchebaggish
    end
  end
  
  private

    def bypass_validation
      if self.changed == ['state']
        save!(:validate => false)
      else
        save!(:validate => true)
      end
    end

    def create_remember_token
      self.remember_token = Client.encrypt(Client.new_remember_token)
    
    end
end
