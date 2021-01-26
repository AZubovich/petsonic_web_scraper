require 'curb'
require 'nokogiri'
require "stringex/unidecoder"
require "stringex/core_ext"
require_relative 'path_helper'
require_relative 'file_helper'

class DataScraping

  include FileHelper
  include PathHelper

  def initialize(argv)
    @argv = argv
  end

  def invalid_url?(url)
    (url =~ %r/^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$/).nil?
  end

  def perform
    if @argv.length != 2
      puts "Error: Should be 2 argument, not #{@argv.length}"
    elsif invalid_url?(@argv[0].to_ascii)
      puts "Error: #{@argv[0]} is not a valid url"
    else
      create_file(@argv[1])
      fetch_products_urls
    end
    puts 'Done!'
    puts (Time.now.to_i - @time1)
  end

  def get_root_element(url)
    html = Curl.get(url)
    doc = Nokogiri::HTML.parse((html.body_str))
    doc.xpath(root_path)
  end

  def fetch_products_urls
    @time1 = Time.now.to_i 
    puts "Fetch #{@argv[0].to_ascii}"
    threads = []
    (1..).each do |i|
      url = @argv[0] + "?p=#{i}"
      url = @argv[0] if i == 1
      root = get_root_element(url.to_ascii)
      threads << Thread.new(i) do |i|
        products = root.xpath(products_path).map { |i| i[:href]}
        fetch_products_info(products)
      end
      break if all_products?(root)
    end
    threads.each{|t| t.join}
  end

  def fetch_products_info(products)
    (0...products.count).each do |i|
      root = get_root_element(products[i].to_ascii)
      title = root.xpath(title_path).text
      images = root.xpath(images_path).map { |i| i[:src] }  
      names = root.xpath(multiproduct_path + names_path).map { |i| i.text }
      prices = root.xpath(multiproduct_path + prices_path).map { |i| i.text.split(' ')[0] }
      puts "Write information to csv file from #{products[i]}"
      write_to_file(@argv[1], title, images, names, prices)
    end
  end

  def all_products?(root)
    count = root.xpath(pagination_count_path).text.split(' ')
    count[3].to_i == count[5].to_i
  end
end