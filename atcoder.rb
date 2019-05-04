require "nokogiri"
require "open-uri"

def get_contest_plan 
    todaytime = Time.new
    if todaytime.hour == 0 then
        return true
    end
end

def contest_search
    url = URI.encode "https://atcoder.jp/contests?lang=ja" 
    atcoder = []
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
                    if a[:href][0] == '/' then                         
                        atcoder.push("https://atcoder.jp" + a[:href])
                        puts atcoder
                    end
                end
            end
        end 
    end
    return atcoder
end

      
