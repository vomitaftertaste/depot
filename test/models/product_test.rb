require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products
  test "products should not be empty" do
    product = Product.new
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:image_url].any?
    assert product.errors[:price].any?
  end

  test "product price must be positive" do
    product = Product.new(title: "My Book title",
                          description: "yyy",
                          image_url: "zzz.jpg")
    product.price = -1
    assert product.invalid?

    product.price = 0
    assert product.invalid?

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(title: "My alskdjasl d",
                description: "asdasdasdsdasdfafa",
                price: 1,
                image_url: image_url)
  end

  test "image url" do
    ok = %w{ fred.gif hdr.png x.jpg FRED.JPG hdr.PNG hdr.Png hdr.Jpg http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |img_url|
      assert new_product(img_url).valid?, "#{img_url} should be valid"
    end
    bad.each do |img_url|
      assert new_product(img_url).invalid?, "#{img_url} should be invalid"
    end
  end

  test "products is not valid without a unique title" do
    product = Product.new(title: products(:ruby).title,
                          description: "yyy",
                          image_url: 'fred.gif',
                          price: 1)
    assert product.invalid?
  end

  test "maximum lenght of title product is 10" do
    product = Product.new(title: "1234567891011121314151617181920",
                          description: "yyy",
                          image_url: 'fred.gif',
                          price: 1)
    assert product.invalid?
  end
end
