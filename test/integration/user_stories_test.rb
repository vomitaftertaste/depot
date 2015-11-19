require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products, :orders

  test "changing ship date" do
    get "/orders/2/edit"
    assert_response :success
    assert_template "edit"

    put_via_redirect "/orders/2",
                      order: {
                          name: "Haidar M",
                          address: "123 The Street",
                          email: "haidar.muhammad@gmail.com",
                          pay_type: "Check",
                          ship_date: Date.strptime('2015-06-23','%Y-%m-%d')
                      }
    assert_response :success
    assert_select '#notice', 'Your order is updated.'

    mail = ActionMailer::Base.deliveries.last
    assert_equal  ["haidar.muhammad@gmail.com"], mail.to
    assert_equal  "Haidar Muhammad <haidar@haidar.com>", mail[:from].value
    assert_equal  "Pragmatic Store Order Shipped", mail.subject

  end

  test "buying a product" do
    LineItem.delete_all
    Order.delete_all
    ruby_book = products(:ruby)

    get "/"
    assert_response :success
    assert_template "index"
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    get "/orders/new"
    assert_response :success
    assert_template "new"

    post_via_redirect "/orders",
        order: {
            name: "Dave Thomas",
            address: "123 The Street",
            email: "dave@example.com",
            pay_type: "Check",
            ship_date: Date.strptime('2015-11-20','%Y-%m-%d')
        }
    assert_response :success
    assert_template "index"
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    assert_equal "Dave Thomas", order.name
    assert_equal "123 The Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type

    assert_equal 1,order.line_items.size
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product

    mail = ActionMailer::Base.deliveries.last
    assert_equal  ["dave@example.com"], mail.to
    assert_equal  "Haidar Muhammad <haidar@haidar.com>", mail[:from].value
    assert_equal  "Pragmatic Store Order Confirmation", mail.subject
  end
end
