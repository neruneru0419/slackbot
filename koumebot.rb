require 'slack-ruby-client'
require './atcoder'

Slack.configure do |conf|
    conf.token = ENV['SLACK_API_TOKEN']
end

client = Slack::Web::Client.new

loop do
    if get_contest_plan and $atflg then
        contest_search
        $atcoder.each do |atlink|        
            client.chat_postMessage(channel: '21_kyopro', text: "今日のAtCoderの情報です\n#{atlink}", as_user: true)
            $atflg = false
        end
        $atcoder.clear
    end
end
