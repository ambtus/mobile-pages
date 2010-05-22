# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  config.remember_for = 2.weeks
end
