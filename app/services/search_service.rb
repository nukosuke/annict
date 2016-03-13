# frozen_string_literal: true

class SearchService
  attr_reader :q

  def initialize(q, scope: :published)
    @q = q
    @scope = scope
  end

  def works
    collection(Work).search(title_cont: @q).result
  end

  def people
    collection(Person).search(name_cont: @q).result
  end

  def organizations
    collection(Organization).search(name_cont: @q).result
  end

  private

  def collection(model)
    case @scope
    when :all
      model
    else
      model.published
    end
  end
end
