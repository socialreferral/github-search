require 'bundler/setup'
require 'sinatra/base'

class GitHubSearch < Sinatra::Base
  set :app_file, __FILE__

  get '/' do
    erb :index, locals: {owner: nil, repository: nil, result: nil}
  end

  get '/:owner/:repository/?*' do
    result = nil
    if params['q']
      result = params['q']
    end
    erb :index, locals: {owner: params['owner'], repository: params['repository'], result: result}
  end
end

