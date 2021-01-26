
module PathHelper

  def products_path
    '//div[@id="center_column"]//ul//li//div[@class="pro_first_box "]//a'
  end

  def root_path
    '//div[@class="main_content_area"]'
  end

  def title_path
    '//h1[@class="product_main_name"]'
  end

  def images_path
    '//div[@id="views_block"]/div[@id="thumbs_list"]//img'
  end

  def multiproduct_path
    '//form[@id="buy_block"]//div[@id="attributes"]//div[@class="attribute_list"]/ul//li//label'
  end

  def names_path
    '//span[@class="radio_label"]'
  end

  def prices_path
    '//span[@class="price_comb"]'
  end

  def pagination_count_path
    '//div[@id="center_column"]/div[@class="content_sortPagiBar"]//div[@class="product-count hidden-xs"]'
  end
end