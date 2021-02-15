class TailwindFormBuilder < ActionView::Helpers::FormBuilder
  def text_field(attribute, options = {})
    super(attribute, options.reverse_merge(class: "text_field"))
  end
end
