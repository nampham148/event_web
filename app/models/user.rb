class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'dummy_email@'
  TEMP_EMAIL_REGEX = /dummy_email@/

  has_many :identities
  has_many :events
  has_many :registrations
  has_many :registered_events, through: :registrations, source: :event
  has_many :messages
  has_many :chatrooms, through: :registered_events

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :twitter, :google_oauth2]

  validates :name, presence: true

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      
      # email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email # if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        password = Devise.friendly_token[0,20]
        user = User.new(
          name: auth.info.name,
          #username: auth.info.nickname || auth.uid,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: password
        )
        user.skip_confirmation!
        user.save!
        UserMailer.omniauth_password(user, password).deliver_now
      end
    end

    #add token
    identity.update_attributes(token: auth.credentials.token)

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def active_event_count
    self.registered_events.active?.count
  end

  def registered?(event)
    self.registered_events.include?(event)
  end

  def register(event)
    self.registered_events << event
  end

  def unregister(event)
    if self.registered?(event)
      self.registered_events.delete(event)
    end
  end

  # MAYBE CAN MAKE THESE TWO METHODS INTO ONE?
  def has_facebook?
    !self.identities.find_by(provider: "facebook").nil?
  end

  def has_twitter?
    !self.identities.find_by(provider: "twitter").nil?
  end

  def update_social
    if self.has_facebook?
      identity = self.identities.find_by(provider: "facebook")
      graph = Koala::Facebook::API.new(identity.token)
      followers = graph.get_connection(identity.uid, 'friends', api_version: 'v2.0').raw_response["summary"]["total_count"]
      identity.update_attributes(follower: followers)
    end
    if self.has_twitter?
      identity = self.identities.find_by(provider: "twitter")
      follower = $twitter.user(identity.uid.to_i).followers_count
      identity.update_attributes(follower: follower)
    end
  end

  def self.update_social_media
    User.find_each do |user|
      user.update_social
    end
  end
end
