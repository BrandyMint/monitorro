require 'open-uri'
require 'rcsv'
require 'benchmark'
require 'zip'
require './lib/auto_logger'

# bm_brates.dat - ???
# bm_info.dat   - Данные об этом пакете. Время обновлеиния и тп
# bm_news.dat   - Тестовые новости BestChange
# bm_top.dat    - ??
#
# Импортируем:
#
# bm_bcodes.dat - Список валют
# bm_cy.dat     - Перечень платежных систем
# bm_rates.dat  - Собственно курсы
# bm_exch.dat   - Список обменников

class BestChangeLoadingWorker
  include Sidekiq::Worker
  include AutoLogger
  include UniqueWorker

  TIMEOUT = 3

  URL = URI.parse 'http://www.bestchange.ru/bm/info.zip'

  def perform
    logger.info "Start"
    directions = {}

    total_bm = Benchmark.measure do
      bm = Benchmark.measure do
        unpack open URL, read_timeout: TIMEOUT, open_timeout: TIMEOUT
      end

      import_exchangers
      logger.info "Download (#{URL}) and unpack done (bm_rates.count: #{bm_rates.count}, benchmark: #{bm.real})"

      # 0 - ps1
      # 1 - ps2
      # 2 - обменник
      # 3 - отдате (сумма)
      # 4 - получаете (сумма) курс = 4/3
      # 5 - резерв
      # 6 - ?
      # 7 - ?
      bm = Benchmark.measure do
        bm_rates.each do |row|
          add_row directions, row
        end
      end


      logger.info "Build done (directions: #{directions.count}, benchmark: #{bm.real})"

      bm = Benchmark.measure do
        directions.each do |key, list|
          BestChangeRatesRepository.setRows key, list.sort
        end
      end
      logger.info "Store done (benchmark: #{bm.real})"
    end

    logger.info "Finish (total benchmark: #{total_bm.real})\n"

    directions.count
  end

  # rates = bm_rates
  # id_best = link_id[v[0]][v[1]]
  # id_exch = v[2]  exchanger_id = v[2].to_i
  # reserf = v[5]
  # outm = v[4] / v[3]
  # take = 1
  # type_cy1 = bank_idb[v[0]][:type_cy]
  # name_change = exchanger_names[exchanger_id]

  private

  attr_reader :bm_rates, :bm_exch

  def import_exchangers
    bm_exch.each do |e|
      id, name = e
      c = BestChangeChangerRow.new(id: id, name: name)
      BestChangeChangersRepository.set id, c
    end

  end

  def add_row(directions, row)
    ps1, ps2, exchanger_id, buy_price, sell_price, reserve = row

    key = BestChangeRatesRepository.build_direcition_key ps1, ps2

    d = directions[key] ||= []
    d << BestChangeRateRow.new(
      exchanger_id:   exchanger_id.to_i,
      buy_price:      buy_price.to_f,
      sell_price:     sell_price.to_f,
      reserve:        reserve,
      time:           time
    )
  end

  def exchanger_names
    @exchanger_names ||= bm_exch.each_with_object({}) { |l, h| h[l[0].to_i] = l[1] }
  end

  # отдаете 702 689.1892
  # от 2810.76
  # получаете 1 BTC
  # резерв 9.25
  # отзывы 0/4855
  # https://www.bestchange.ru/qiwi-to-bitcoin.html
  # https://www.bestchange.ru/click.php?id=522&from=63&to=93
  # r.find { |a| a[0].to_i == 63 && a[1].to_i == 93 && a[2].to_i == 522 }
  def unpack(file)
    Zip::File.open file do |zip_file|
      # Список обменников
      # Пример: ["522", "Касса", nil, "0", "601454"]
      @bm_exch = parse_csv zip_file.glob('bm_exch.dat').first.get_input_stream.read

      # rateindex = (1 - $v[4] * $list_kurs[$list_item['type_cy1']][$list_item['type_cy2']][0] / $v[3]) * 100
      # outm = v[4] / v[3]
      #  ps1,  ps2, exchanger_id, отдаете, получаете, reserv, ?, ?
      # ["63", "93", "522", "702689.18918919", "1", "9.24", "0.0", "1"]
      @bm_rates = parse_csv zip_file.glob('bm_rates.dat').first.get_input_stream.read
    end
  end

  def parse_csv(content)
    Rcsv.parse content.force_encoding('cp1251').encode, column_separator: ';'
  end

  def time
    @time ||= Time.zone.now.to_i
  end
end
