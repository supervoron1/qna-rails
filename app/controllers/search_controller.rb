class SearchController < ApplicationController
  def search
    set_params
    @result = FulltextSearch.new(@query, @scope, params[:page]).call unless @query.empty?
  end

  private

  def set_params
    @scope = params[:scope] || 'all'
    @query = params[:q].to_s
  end
end