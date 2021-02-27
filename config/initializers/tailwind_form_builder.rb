class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  # def text_field(attribute, options = {})
  #   @template.content_tag :div, class: "mt-1" do
  #     super(attribute, options.reverse_merge(class: "text-input"))
  #   end
  # end

  %w[text_field text_area password_field rich_text_area].each do |method_name|
    define_method(method_name) do |name, title, *args|
      @template.content_tag :div do
        label(name, title, class: "block text-sm font-medium text-gray-700") +
        (@template.content_tag :div, class: "mt-1" do
          super(name, options.reverse_merge(class: "text-input"))
        end)
      end
    end
  end
end
