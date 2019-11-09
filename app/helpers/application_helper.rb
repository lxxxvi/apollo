module ApplicationHelper
  def colorize_text(text, state)
    content_tag(:span, text, class: "text-poll-state-#{state}")
  end

  def emphasize(text)
    content_tag(:strong, text)
  end

  def background_image_property(base64)
    "background-image: url('data:image/svg+xml;base64,#{base64}');"
  end
end
