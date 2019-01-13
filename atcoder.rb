require "nokogiri"
require "open-uri"

$timecount = true
def get_contest_plan 
    todaytime = Time.new
    if todaytime.hour == 0 and $timecount then
        $timecount = false
        return true
    elsif todaytime.hour == 0 and !$timecount 
        return false
    else
        $timecount = true 
        return false
    end
end

def contest_search
    url = URI.encode "https://atcoder.jp/contests?lang=ja" 
    $atcoder = Array.new
    $atflg = false
    today = Time.new.to_s.slice(0..9)
    page = ""
    charset = nil
    html = open(url) do |f|
        charset = f.charset 
        f.read 
    end
    doc = Nokogiri::HTML.parse(html, nil, charset)
    doc.css('tr').each do |tr|
        tr.css('td').each do |td|
            td.css('time').each do |time|
                page = time.text.slice(0..9)
                puts page
            end
            if page == today then
                td.css('a').each do |a|
                    $count = 0
                    if a[:href][0] == '/' then                         
                        $atcoder[$count] =  "https://atcoder.jp" + a[:href]
                        puts $atcoder[$count]
                        $count += 1
                        $atflg = true
                    end
                end
            end
        end 
    end
end

      