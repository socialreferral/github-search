require 'bundler/setup'
require 'sinatra/base'
require 'coderay'

class GitHubSearch < Sinatra::Base
  set :app_file, __FILE__

  get '/' do
    erb :index, locals: {owner: nil, repository: nil, result: nil}
  end

  get '/:owner/:repository/?*' do
    result = nil
    owner = params['owner']
    repository = params['repository']
    data_dir = "#{File.dirname(__FILE__)}/data"
    if File.directory?("#{data_dir}/#{owner}/#{repository}")
      `cd #{data_dir}/#{owner}/#{repository} && git pull`
    else
      `mkdir -p #{data_dir}/#{owner} && cd #{data_dir}/#{owner} && git clone https://github.com/#{owner}/#{repository}.git`
    end
    if params['q']
      result = `cd #{data_dir}/#{owner}/#{repository} && ack-grep -a -C '#{params['q']}'`.split("--\n")
      result = result.map do |snip|
        match_data = /^(.+)(-(\d+)-|:(\d+):)/.match(snip)
        file_name = match_data[1]
        line_number = match_data[3].to_i
        snip.gsub!(/^.*(-\d+-|:\d+:)/, '')
        CodeRay.scan(snip, :ruby).div(:line_numbers => :table, :line_number_start => line_number)
      end
      result = result.join("")
    end
    erb :index, locals: {owner: owner, repository: repository, result: result}
  end
end

