require 'bundler/setup'
require 'sinatra/base'

class GitHubSearch < Sinatra::Base
  set :app_file, __FILE__

  get '/:owner/:repository/?*' do
    erb :index, locals: {owner: params['owner'], repository: params['repository']}
  end
end

