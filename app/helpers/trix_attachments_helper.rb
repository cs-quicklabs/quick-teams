module TrixAttachmentsHelper
  def extract_trix_content(body)
    doc = Nokogiri::HTML(body.to_html)
    files = []
    text_content = ""
    doc.css("action-text-attachment").each do |attachment|
      files << attachment["filename"]
    end
    text_content = doc.text
    if !text_content.blank?
      return text_content
    else
      return "Attached files: #{files.join(", ")}"
    end
  end
end
