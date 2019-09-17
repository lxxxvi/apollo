module ApplicationHelper
  def colorize_text(text, state)
    content_tag(:span, text, class: "text-poll-state-#{state}")
  end
end
