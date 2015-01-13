module Lucrative
  class Ad
    @@x, @@y = 1, 1

    # Reads through sample data file on object intitialization and loads the data into Hash variable
    #
    def initialize
      @advertisements = {}
      CSV.foreach(File.dirname(__FILE__) + '/../lib/advertisements/sample_data.csv', :headers=>true) do |row|
        if @advertisements[row['size']]
          if @advertisements[row['size']] < row['price'].to_f
            @advertisements[row['size']] = row['price'].to_f
          end
        else
          @advertisements = @advertisements.merge({row['size'] => row['price'].to_f})
        end
      end
    end

    # Takes and organises the ads by priority
    # Returns most lucrative advertizement combination
    #
    def most_lucrative_combination
      @ordered_ads = order_by_priority(@advertisements)
      total_blocks, flag = 0, false

      while true
        if total_blocks != 9
          @ordered_ads.shift if flag
          if @ordered_ads.empty?
            break
          else
            most_lucrative_combination, total_blocks = most_lucrative(@ordered_ads)
            flag = true
          end
        else
          break
        end
      end

      return most_lucrative_combination

    end
    
    # Prioritize ads by considering the price and total block size(9)
    # Returns ordered array of sizes
    # Example ['2X3', '1X3', '3X3']
    #
    def order_by_priority ads
      prioritized_hash = {}
      ads.each_pair do |k,v|
        i = multiply_dimentions(k)
        for_one_percent_of_area = v/((i.to_f/9)*100)
        prioritized_hash = prioritized_hash.merge({k => for_one_percent_of_area})
      end
      Hash[prioritized_hash.sort_by{|k, v| v}.reverse].keys  
    end

    # Multiplies the size values
    # Returns for example '2X3'=6
    #
    def multiply_dimentions size
      size.scan(/\d+/).map(&:to_i).inject(:*)
    end

    # Gets the prioritized array of sizes
    # By checking total number of blocks and horizontalXvertical blocks space 
    # left it will fill up most lucrative combination.
    # Returns most lucrative combination and total blocks count
    #
    def most_lucrative ads
      total_blocks, most_lucrative_combination = 0, {}

      ads.each do |a|

        while true
          
          count = multiply_dimentions(a)

          if count+total_blocks > 9 || limit_exceeded?(a)
            break
          else
            total_blocks += count
            if most_lucrative_combination[a]
              most_lucrative_combination[a] += 1
            else
              most_lucrative_combination = most_lucrative_combination.merge({a => 1})
            end
          end

        end

      end
      return [most_lucrative_combination,total_blocks]
    end

    # Receives ad size
    # Checks if horizontaXverticle limit or block space exceeded
    # Returns return_value, true or false
    #
    def limit_exceeded? size
      return_value = false
      xandy = size.scan(/\d+/).map(&:to_i)
      first = xandy.first
      last = xandy.last

      if first > last
        if @@x*first > 9
          return_value = true
        else
          @@x *= first
        end
      elsif first < last
        if @@y*last > 9
          return_value = true
        else
          @@y *= last
        end
      else
        first_last = first*last
        if @@x*first_last > 9 && @@y*first_last > 9
          return_value = true
        else
          @@x *= first_last
          @@y *= first_last
        end
      end

      return return_value
    end

  end
end