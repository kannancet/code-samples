module CompaniesHelper

  #Function to render collapse class
  def collapse_class(index)
  	index == 0 ? "collapse in" : "collapse"
  end

  #Funciton to show and hide log
  def show_hide_log(log)
  	log.blank? ? "display: none;" : ""
  end

  #Function to show succeded rows
  def suceeded_rows(log)
  	log ? log.total_rows_suceeded : 0
  end

  #Function to show failed rows
  def failed_rows(log)
  	log ? log.total_rows_failed : 0
  end

  #Function to show total rows
  def total_rows(log)
  	log ? log.total_rows_parsed : 0
  end
end
