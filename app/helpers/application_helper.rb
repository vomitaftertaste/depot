module ApplicationHelper
  def hidden_div_if(condition, attributes = {}, &block)
    if condition
      attributes[:style] = 'display: none'
    end
    content_tag('div',attributes,&block)
  end

  def user_login(name, password)
    user = User.find_by(name: name)
    if ( User.all.empty? ) || ( user && user.authenticate(password) )
      session[:user_id] = user ? user.id : 0
      return true
    else
      return false
    end
  end

  def user_login?
    return User.find_by(id:session[:user_id]) || session[:user_id] == 0
  end

end
