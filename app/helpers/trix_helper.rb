module TrixHelper
  SCRUBBER = Loofah::Scrubber.new do |node|
    node[:target] = "_blank" if node.name == "a"
  end

  # Overriding https://github.com/rails/rails/blob/da795a678b341adc8031c4d9cf0b5ef2176e2a5a/actiontext/app/helpers/action_text/content_helper.rb#L17
  def sanitize_action_text_content(content)
    original_scrubber, self.scrubber = self.scrubber, SCRUBBER
    super
  ensure
    self.scrubber = original_scrubber
  end
end
