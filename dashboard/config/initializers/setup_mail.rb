ActionMailer::Base.smtp_settings = {
  :address              => OKConfig[:mail_address],
  :port                 => OKConfig[:mail_port],
  :domain               => OKConfig[:mail_domain],
  :user_name            => OKConfig[:mail_user_name],
  :password             => OKConfig[:mail_password],
  :authentication       => OKConfig[:mail_authentication],
  :enable_starttls_auto => OKConfig[:mail_enable_starttls_auto]
}

mailer_host = OKConfig[:mail_host]
ActionMailer::Base.default_url_options[:host] = mailer_host
# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
