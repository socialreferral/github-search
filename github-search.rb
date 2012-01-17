require 'bundler/setup'
require 'sinatra/base'

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
      result = `cd #{data_dir}/#{owner}/#{repository} && ack-grep -a '#{params['q']}'`
    end
    erb :index, locals: {owner: owner, repository: repository, result: result}
  end
end

