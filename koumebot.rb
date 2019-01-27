require 'slack-ruby-client'
require './atcoder'

Slack.configure do |conf|
conf.token = ENV['SLACK_API_TOKEN']
end
client = Slack::Web::Client.new
loop do
    if get_contest_plan() then
        contest_search()
        if $atflg then
            $atcoder.each do |atlink|        
                client.chat_postMessage(channel: 'kyopro', text: "今日のAtcoderの情報です\n#{atlink}", as_user: true)
                $atflg = false
                $atcoder.clear
            end
        end
    end
end
