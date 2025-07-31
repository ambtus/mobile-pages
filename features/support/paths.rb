# frozen_string_literal: true

module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I am on (.+)$/ do |page_name|
  #
  # step definition in my_web_steps.rb
  #
  def path_to(page_name)
    case page_name

    # FIXME
    # this isn't actually the homepage
    # all the tests need to be rewritten
    when /the homepage/
      '/pages'

    when /^the page's page/
      page = Page.find_by(title: 'Page 1') || Page.first
      raise 'no pages' unless page

      page_path(page)

    when /^the page with title "(.*)"/
      title = ::Regexp.last_match(1)
      page = Page.find_by(title: title)
      raise "no page with title: #{title}" unless page

      page_path(page)

    when /^the page with url "(.*)"/
      url = ::Regexp.last_match(1)
      page = Page.find_by(url: url)
      raise "no page with url: #{url}" unless page

      page_path(page)

    when /^the edit tag page for "(.*)"$/
      edit_tag_path(Tag.find_by(name: ::Regexp.last_match(1)))

    when /^the create page$/
      new_page_path

    when /^the "Store Multiple" page$/
      new_part_path

    when /^the filter page$/
      filter_path

    else
      begin
        page_name =~ /the (.*) page/
        path_components = ::Regexp.last_match(1).split(/\s+/)
        send(path_components.push('path').join('_').to_sym)
      rescue Object
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" \
              "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
