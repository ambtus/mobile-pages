# frozen_string_literal: true

class Render
  URL = 'http://mp.ambt.us'

  class << self
    def render_html(page, rerender: false)
      file = page.temporary_file('.html')
      return file if File.exist?(file) && !rerender

      Rails.logger.debug { 'rendering html' }
      html = ApplicationController.render(
        template: 'downloads/show',
         assigns: { page: page, url: URL },
          layout: 'downloads'
      )
      Rails.logger.debug { "writing #{html.size} chars to file #{file}" }
      File.write(file, html)
    end

    def render_read_aloud(page, rerender: false)
      file = page.temporary_file('.read')
      return file if File.exist?(file) && !rerender

      Rails.logger.debug { 'rendering read aloud html' }
      html = ApplicationController.render(
        template: 'downloads/read',
         assigns: { page: page, url: URL },
          layout: 'downloads'
      )
      Rails.logger.debug { "writing #{html.size} chars to file #{file}" }
      File.write(file, html)
    end

    def render_epub(page, rerender: false)
      render_html(page, rerender: rerender)

      file = page.temporary_file('.epub')
      return file if File.exist?(file) && !rerender

      Rails.logger.debug { 'rendering epub' }

      `#{page.epub_command} 2> /dev/null`
    end
  end
end
