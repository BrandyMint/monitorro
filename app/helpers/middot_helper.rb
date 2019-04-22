module MiddotHelper
  MIDDOT = '&middot;'.html_safe.freeze

  def middot(buffer = nil)
    buffer.presence || MIDDOT
  end
end
