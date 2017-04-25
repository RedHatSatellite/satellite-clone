class PackagingHelpers
  def self.yesno
    begin
      system("stty raw -echo")
      str = STDIN.getc
    ensure
      system("stty -raw echo")
    end
    if str.chr.downcase == "y"
      return true
    elsif str.chr.downcase == "n"
      return false
    else
      puts "Invalid Character. Try again: [y/n]"
      yesno
    end
  end
end
