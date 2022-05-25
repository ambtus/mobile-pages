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
      page = Page.find_by_title("Page 1") || Page.first
      raise "no pages" unless page
      page_path(page)

    when /^the page with title "(.*)"/
      title = $1
      page = Page.find_by_title(title)
      raise "no page with title: #{title}" unless page
      page_path(page)

    when /^the page with url "(.*)"/
      url = $1
      page = Page.find_by_url(url)
      raise "no page with url: #{url}" unless page
      page_path(page)

    when /^the edit tag page for "(.*)"$/
      edit_tag_path(Tag.find_by_name($1))

    when /^the create page$/
      new_page_path

    when /^the "Store Multiple" page$/
      new_part_path

    when /^the filter page$/
      filter_path

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
