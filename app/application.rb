require 'pry'
class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new #response
    req = Rack::Request.new(env) #request ## thought we were supposed to be clear with our local variables

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/) #new if conditional for each route, separated by elsifs
      if @@cart.empty?
        resp.write "Your cart is empty" 
      else @@cart.each do |item|
          resp.write "#{item}\n"
        end
      end
    else req.path.match(/add/)
      search_term = req.params["item"] #how can we just call handle_search?
      if @@items.include?(search_term)
        @@cart << search_term
        resp.write "added #{search_term}"        
      else
        resp.write "We don't have that item"
      end
    end
    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

  
end
