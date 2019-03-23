# Periodicaly start fetching exchange rates data
#
class FetchingMetronomeWorker
  def perform
    Exchange.available.pluck(:id).each do |id|
      ImportWorker.perform_async id
    end
  end
end
