require 'slack-ruby-client'
require './atcoder'

Slack.configure do |conf|
conf.token = ENV['SLACK_API_TOKEN']
end

client = Slack::Web::Client.new

loop do
    client.chat_command(channel:'C8DCH0KA6', command:'/hoge')
    if get_contest_plan then
        contest_search
        if $atflg then
            $atcoder.each do |atlink|        
                client.chat_postMessage(channel: '21_kyopro', text: "今日のAtCoderの情報です\n#{atlink}", as_user: true)
                $atflg = false
           　end
            $atcoder.clear
        end
    end
end
