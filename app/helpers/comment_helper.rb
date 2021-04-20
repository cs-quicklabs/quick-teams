module CommentHelper
  def comment_status_color(comment)
    bg_color = "bg-gray-100"
    text_color = "text-gray-800"

    if comment.progress?
      bg_color = "bg-green-100"
      text_color = "text-green-800"
    elsif comment.regress?
      bg_color = "bg-red-100"
      text_color = "text-red-800"
    end
    bg_color + " " + text_color
  end
end
