class ArticlesController < ItemController
  before_filter :check_admin, :except => [:index, :show]
  make_resourceful do 
    build :all
  end
end
