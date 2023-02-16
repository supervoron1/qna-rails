class FulltextSearch
  attr_reader :query, :scope, :page

  def initialize(query, scope, page = 1)
    @query = ThinkingSphinx::Query.escape(query)
    @scope = scope
    @page = page || 1
  end

  def call
    if @scope == 'all'
      result = ThinkingSphinx.search @query, classes: [Question, Answer, Comment, User], page: @page
    else
      result = model_klass.search @query, page: @page
    end
    result
  end

  private

  def model_klass
    @scope.classify.constantize
  end
end