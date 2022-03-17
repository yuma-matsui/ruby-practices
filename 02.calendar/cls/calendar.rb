require 'date'

class Calendar
  def initialize(month, year)
    @today = Date.today
    @month = month || @today.month
    @year = year || @today.year
    print_header
    print_week
    print_calendar
  end

  private

  # 見出しの年月表示用
  def print_header
    puts "#{@month}月 #{@year}".center(28)
  end
  
  # 見出しの曜日表示用
  def print_week
    week = [' 日 ', ' 月 ', ' 火 ', ' 水 ', ' 木 ', ' 金 ', ' 土 ']
    puts "#{week.join}"
  end
  
  # カレンダーの出力
  def print_calendar
    (Date.new(@year, @month, 1)..Date.new(@year, @month, -1)).each do |d|
      str = insert_space(d)
      # 月の指定が今月の場合の今日の日付の出力色反転
      print d == @today ? "\e[47m\e[30m#{str}\e[0m" : str
      # 曜日が土曜日の時の改行
      puts if d.wday == 6
    end
  end
  
  # カレンダーの各日付の空白挿入処理
    def insert_space(d)
      # 月の初日が日曜日以外の場合に空白を挿入
      print "    " * d.wday if (d.wday != 0) && (d.day == 1)
      
      str = d.day.to_s
      if d.day >= 10
        str.center(4)
      else
        str.rjust(3).ljust(4)
      end
    end
end
