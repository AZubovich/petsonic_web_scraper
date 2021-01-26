require 'csv'

module FileHelper

  def create_file(file)
    puts "Create file #{file}.csv"
    CSV.open("#{file}.csv", 'w') do |csv|
      csv << ["Name", "Price", "Image"]
    end
  end

  def write_to_file(file, title, images, names, prices)
    CSV.open("#{file}.csv", 'a+') do |csv|
      (0...names.count).each do |i|
        images[i] = images[0] if images[i].nil?
        images[i] = 'none' if images[0].nil?
        csv << ["#{title} - #{names[i]}", prices[i], images[i]]
      end
    end
  end
end
