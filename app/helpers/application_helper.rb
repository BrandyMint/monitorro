module ApplicationHelper
  def app_title
    "best rate demo #{AppVersion}"
  end

  def humanized_time(time)
    return '-' unless time

    content_tag :span, title: time.to_s do
      l time, format: :short
    end
  end
end
