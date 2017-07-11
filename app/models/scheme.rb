class Scheme < ApplicationRecord
  has_many :values

  validates_uniqueness_of :code

  def self.fetch_all_data
    start_date = "01-Apr-2015".to_datetime.to_date.to_s
    end_date = DateTime.now.to_date.to_s
    Scheme.fetch_and_store_data(start_date, end_date)
  end

  def self.fetch_daily_data
    start_date = (DateTime.now-1.day).to_date.to_s
    end_date = DateTime.now.to_date.to_s
    Scheme.fetch_and_store_data(start_date, end_date)
  end

  def self.fetch_and_store_data(start_date, end_date)
    url = URI.parse("http://portal.amfiindia.com/DownloadNAVHistoryReport_Po.aspx?mf=53&tp=1&frmdt="+start_date+"&todt="+end_date)
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }

    res.body.split("\n").each do |line|
      if (line =~ /^\d/).present?
        fields = line.split("\;")
        scheme_code = fields[0]
        scheme_name = fields[1]
        price = fields[4]
        date = fields[5].to_datetime.to_date.to_s
        scheme = Scheme.find_by_code(scheme_code)
        if scheme.blank?
          scheme = Scheme.new(:code => scheme_code, :name=>scheme_name)
          scheme.save
        end
        scheme.values.new(:price => price, :date => date).save
      end
    end
  end

  def self.calculate_investment(schemes)
    schemes = [] if schemes.blank?
    total_investment = 0
    schemes.each do |scheme|
      total_investment += scheme["amount"].to_f
    end
    total_investment
  end

  def self.calculate_return(schemes)
    schemes = [] if schemes.blank?
    total_return = 0
    schemes.each do |scheme|
      values = Scheme.find_by_code(scheme["code"]).values
      if values.where(:date => scheme["date"].to_datetime.to_date).first.present?
        purchasing_price = values.where(:date => scheme["date"].to_datetime.to_date).first.price.to_f
      else
      	purchasing_price = values.where("date < ?", scheme["date"].to_datetime.to_date).order('date desc').first.price.to_f
      end
      scheme["units"] = (scheme["amount"].to_f/purchasing_price)
      if values.where(:date => DateTime.now.to_date).first.present?
      	selling_price = values.where(:date => DateTime.now.to_date).first.price.to_f
      else
      	selling_price = values.where("date < ?", DateTime.now.to_date).order('date desc').first.price.to_f
      end
      total_return += (selling_price*scheme["units"].to_f)
    end
    total_return.round(3)
  end
end
