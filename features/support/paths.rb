module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I am on (.+)$/ do |page_name|
  #
  # step definition in my_web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the homepage/
      '/'

    when /^the page's page/
      page = Page.find_by_title("Page 1")
      raise "no page with title: Page 1" unless page
      page_path(page)

    when /^the page with title "(.*)"/
      title = $1
      page = Page.find_by_title(title)
      raise "no page with title: #{title}" unless page
      page_path(page)

    when /^the edit tag page for "(.*)"$/
      edit_tag_path(Tag.find_by_name($1))

    when /^the edit hidden page for "(.*)"$/
      edit_hidden_path(Hidden.find_by_name($1))

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
