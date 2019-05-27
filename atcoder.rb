require "nokogiri"
require "open-uri"
require "http"

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

def notify_contest
    contest_list = []
    if get_contest_plan then
    contest_list = contest_search
        if not contest_list.empty? then
            response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
                token: ENV['SLACK_API_TOKEN'],
                text: "今日のAtCoderのコンテストです",
                channel: "CFCGH89NZ",
                as_user: true,
            })
            contest_list.each do |atlink|        
                response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
                    token: ENV['SLACK_API_TOKEN'],
                    text: atlink,
                    channel: "CFCGH89NZ",
                    as_user: true,
                })
            end
            sleep(3600)
        end
    end
end

def contest_request
    contest_link = ""
    time = Time.now
    flg = false
    res = HTTP.post("https://slack.com/api/im.history", params: {
        token: ENV['SLACK_API_TOKEN'],
        channel: "DEXLQN4VA",#"DJUDDDD6D",
        count: 1,
    })
    response = JSON.parse(res)
    ts = response["messages"][0]["ts"]

    if response["messages"][0]["ts"] != ts then
        contest_link = response["messages"][0]["text"]
        ts = response["messages"][0]["ts"]
        flg = true
    else
        sleep(60)
    end

    if time == 12 and flg then
        response = HTTP.post("https://slack.com/api/chat.postMessage", params: {
            token: ENV['SLACK_API_TOKEN'],
            text: "今日の1day1commitの問題です\n#{contest_link}",
            channel: "CFCGH89NZ",
            as_user: true,
        })
        contest_link = ""
        flg = false
        sleep(3600)
    end
end
