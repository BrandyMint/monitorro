require 'settingslogic'
if defined? Rails
  class Settings < Settingslogic
    source "#{Rails.root}/config/settings.yml"
    namespace Rails.env
    suppress_errors Rails.env.production?
  end
else
  class Settings < Settingslogic
    source "./config/settings.yml"
    namespace 'development'
  end
end
