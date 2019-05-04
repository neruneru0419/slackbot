require 'slack-ruby-client'
require './atcoder'

Slack.configure do |conf|
    conf.token = ENV['SLACK_API_TOKEN']
end

client = Slack::Web::Client.new
contest_list = []
loop do
    if get_contest_plan then
        contest_list = contest_search
        if not contest_list.empty? then
            client.chat_postMessage(channel: '21_kyopro', text: "今日のAtCoderのコンテストです", as_user: true)
            contest_list.each do |atlink|        
                client.chat_postMessage(channel: '21_kyopro', text: "#{atlink}", as_user: true)
            end
            sleep(3600)
        end
    end
end
