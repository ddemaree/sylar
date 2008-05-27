module ApplicationHelper
  
  def system_message_class
    flash[:alert] ? "alert" : "message"
  end
  
end
