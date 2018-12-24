require 'slack-ruby-client'
require 'nokogiri'
require 'open-uri'

Slack.configure do |conf|
conf.token = ENV['SLACK_API_TOKEN']
end

# RTM Clientのインスタンス生成
client = Slack::RealTime::Client.new

# slackに接続できたときの処理
client.on :hello do
puts 'connected!'
client.message channel: 'botテスト', text: 'connected!'
end

client.on :message do |data|
    puts data
    if data['text'] == '<@UEXQQH88M>' then
        client.message channel: data['channel'], text: "単語を入力してください"
        
    elsif data['text'].include?('<@UEXQQH88M>')
        data['text'].slice!('<@UEXQQH88M>')
        url = URI.encode "https://news.google.com/search?q=#{data['text']}&hl=ja&gl=JP&ceid=JP%3Aja"
        puts url
        charset = nil
        html = open(url) do |f|
            charset = f.charset 
            f.read 
        end
            
        doc = Nokogiri::HTML.parse(html, nil, charset)
        count = 0
        doc.css('h3').each do |sample|
            sample.css('a').each do |hoge|
                #puts hoge.text
                $hoge = hoge.text
                $link = ("https://news.google.com" + hoge[:href])
                $link.slice!("https://news.google.com".length)
                count += 1
                if count == 1 then
                    break
                end
            end
            if count == 1 then
                break
            end
        end
       
        client.message channel: data['channel'], text: "#{$hoge}\n#{$link}"
        $hoge = " "
        $link = " "
    end
    if data['text'].include?('こんにちは')
        client.message channel: data['channel'], text: "Hi!"
    end
    
end

client.start!