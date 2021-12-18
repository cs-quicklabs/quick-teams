class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  %w[rich_text_area].each do |method_name|
    define_method(method_name) do |name, title, *args|
      @template.content_tag :div do
        label(name, title, class: "block text-sm font-medium text-gray-700") +
        (@template.content_tag :div, class: "mt-1" do
          super(name, options.reverse_merge(class: "form-text-field"))
        end)
      end
    end
  end

  def text_field(method, title, opts = {})
    default_opts = { class: "form-text-field #{"border-red-400" if @object.errors.any?}" }
    merged_opts = default_opts.merge(opts)
    @template.content_tag :div do
      label(method, title, class: "block text-sm font-medium text-gray-700") +
      (@template.content_tag :div, class: "mt-1" do
        super(method, merged_opts)
      end)
    end
  end

  def text_area(method, title, opts = {})
    default_opts = { class: "form-text-field h-24" }
    merged_opts = default_opts.merge(opts)
    @template.content_tag :div do
      label(method, title, class: "block text-sm font-medium text-gray-700") +
      (@template.content_tag :div, class: "mt-1" do
        super(method, merged_opts)
      end)
    end
  end

  def password_field(method, title, opts = {})
    default_opts = { class: "form-text-field #{"border-red-400" if @object.errors.any?}" }
    merged_opts = default_opts.merge(opts)
    @template.content_tag :div do
      label(method, title, class: "block text-sm font-medium text-gray-700") +
      (@template.content_tag :div, class: "mt-1" do
        super(method, merged_opts)
      end)
    end
  end
end
