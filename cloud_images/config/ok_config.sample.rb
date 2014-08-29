module OKConfig
  extend self

  def config_hash
    @config_hash ||= begin
    {
      :database_name             => nil || 'ok_api',
      :database_username         => nil || 'root',
      :database_password         => nil || ENV['MYSQL_ENV_MYSQL_ROOT_PASSWORD'] || 'gameeso',
      :database_host             => nil || ENV['MYSQL_PORT_3306_TCP_ADDR'] || '127.0.0.1',
      :database_port             => nil || ENV['MYSQL_PORT_3306_TCP_PORT'] || '3306',
      :redis_host                => nil || '127.0.0.1',
      :redis_port                => nil || '6379',
      :mail_address              => nil || 'smtp.example.com',
      :mail_port                 => nil || '465',
      :mail_domain               => nil || 'example.com',
      :mail_user_name            => nil || 'username@example.com',
      :mail_from                 => nil || 'Gameeso <noreply@gameeso.com>',
      :mail_password             => nil || 'replaceme',
      :mail_authentication       => nil || 'plain',
      :mail_enable_starttls_auto => nil || false,
      :mailer_host               => nil || 'www.example.com',
      :aws_key                   => nil || ENV['AWS_ACCESS_KEY_ID']     || 'public-aws-key',
      :aws_secret                => nil || ENV['AWS_SECRET_ACCESS_KEY'] || 'signing-key',
      :s3_attachment_bucket      => nil || ENV['OK_S3_ATTACHMENT_BUCKET'],
      :rails_secret_token        => nil || '15a4c101b9dc5a9eb0a95b81a983aa0a3ffb58c4dc910ca102a226402f39349c8cb267a6ac90371459001ad7aabab99a85ce5ba23f30abc55471f6ef788e972f',
      :rails_session_store_key   => nil || '_openkit_session',
      :apns_host                 => nil || 'gateway.push.apple.com',
      :apns_pem_path             => nil || '/var/gameeso/apple_certs/production',
      :apns_sandbox_host         => nil || 'gateway.sandbox.push.apple.com',
      :apns_sandbox_pem_path     => nil || '/var/gameeso/apple_certs/sandbox',
    }
    end
  end

  def [](k)
    config_hash[k]
  end
end
