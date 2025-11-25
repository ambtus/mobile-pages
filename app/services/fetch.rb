# frozen_string_literal: true

module Fetch
  class << self
    def where
      if ENV['LOUDM'].present?
        $stdout
      elsif Rails.env.test?
        '/tmp/mp_test_mechanize.log'
      elsif Rails.env.development?
        '/tmp/mp_development_mechanize.log'
      elsif Rails.env.production?
        'log/mechanize.log'
      else
        raise 'where do you want the mechanize log to go?'
      end
    end

    def agent
      @agent ||= Mechanize.new do |a|
        a.log = ActiveSupport::Logger.new(where).tap do |logger|
          logger.formatter = proc do |severity, datetime, _progname, msg|
            # Customize the log message format here
            # Example: "Timestamp | Severity | Message\n"
            "#{datetime.strftime('%Y-%m-%d %H:%M:%S')} | #{severity} | #{msg}\n"
          end
        end
        a.open_timeout = 10
        a.read_timeout = 10
      end
    end

    def fetch_html(url)
      Rails.logger.debug { "fetch html: #{url}" }
      raise if url.blank?

      auth = MyWebsites.getpwd(url)
      Fetch.agent.add_auth(url, auth[:username], auth[:password]) if auth
      if url.match?('archiveofourown.org')
        Rails.logger.debug { "ao3 fetch #{url}" }
        content = Fetch.agent.get(url)
        if Fetch.agent.page.uri.to_s == 'https://archiveofourown.org/'
          Rails.logger.debug 'ao3 redirected back to homepage'
          raise
        end
        unless content.links.third.text.match(auth[:username])
          Rails.logger.debug 'ao3 sign in'
          content = Fetch.agent.get('https://archiveofourown.org/users/login?restricted=true')
          form = content.forms.first
          username_field = form.field_with(name: 'user[login]')
          username_field.value = auth[:username]
          password_field = form.field_with(name: 'user[password]')
          password_field.value = auth[:password]
          Fetch.agent.submit(form, form.buttons.first)
          content = Fetch.agent.get(url)
        end
      else
        content = Fetch.agent.get(Websites.geturl(url))
        if content.forms.first.try(:button).try(:name) == 'adult_check'
          Rails.logger.debug 'adult check'
          form = content.forms.first
          content = Fetch.agent.submit(form, form.buttons.first)
        end
      end
      content.body.force_encoding(Fetch.agent.page.encoding)
    end
  end
end
