class Admin::ExchangeLinksController < Admin::ApplicationController
  def new
    render locals: {
      form: ExchangeLinksForm.new
    }
  end

  def create
    form = ExchangeLinksForm.new params[:exchange_links_form].permit!

    render locals: {
      results: AddXmlLinks.new(links: form.links.lines.map(&:chomp).map(&:presence).compact).perform
    }
  end
end
