class StaticPagesController < ApplicationController
  def home
    @projects1 = Project.last(3).reverse!
    @projects2 = Project.offset(3).last(3).reverse!
  end

  def help
  end

  def about

  end

  def contact

  end
end
