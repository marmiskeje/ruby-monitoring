class HomeController < ActionController::Base
  protect_from_forgery with: :exception
  def index
    render file: Rails.public_path.join("home","index.html"), layout: false
  end
end
