module MoviesHelper
  # Checks if a number is odd:
  def oddness(count)
    count.odd? ?  "odd" :  "even"
  end
  
  def prev_col_reset(column)
    @last_column == column ? @next_order : true
  end
end
