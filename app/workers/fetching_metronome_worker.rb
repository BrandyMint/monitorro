# Periodicaly start fetching exchange rates data
#
class FetchingMetronomeWorker
  def perform
    Exchange.available.pluck(:id).each do |id|
      ImportWorker.new.perform id
    end
  end
end
